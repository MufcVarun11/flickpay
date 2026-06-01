#!/usr/bin/env python3
"""Generate FlickPay launcher and splash assets without third-party packages."""

from __future__ import annotations

import math
import os
import struct
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


Color = tuple[int, int, int, int]


def lerp(a: int, b: int, t: float) -> int:
    return round(a + (b - a) * t)


def mix(c1: Color, c2: Color, t: float) -> Color:
    return (
        lerp(c1[0], c2[0], t),
        lerp(c1[1], c2[1], t),
        lerp(c1[2], c2[2], t),
        lerp(c1[3], c2[3], t),
    )


class Canvas:
    def __init__(self, width: int, height: int, bg: Color = (0, 0, 0, 0)) -> None:
        self.width = width
        self.height = height
        self.pixels = bytearray(bg * (width * height))

    def blend_pixel(self, x: int, y: int, color: Color, coverage: float = 1.0) -> None:
        if x < 0 or y < 0 or x >= self.width or y >= self.height:
            return
        sr, sg, sb, sa = color
        a = max(0.0, min(1.0, (sa / 255) * coverage))
        if a <= 0:
            return

        idx = (y * self.width + x) * 4
        dr, dg, db, da = self.pixels[idx : idx + 4]
        da_f = da / 255
        out_a = a + da_f * (1 - a)
        if out_a <= 0:
            return
        self.pixels[idx] = round((sr * a + dr * da_f * (1 - a)) / out_a)
        self.pixels[idx + 1] = round((sg * a + dg * da_f * (1 - a)) / out_a)
        self.pixels[idx + 2] = round((sb * a + db * da_f * (1 - a)) / out_a)
        self.pixels[idx + 3] = round(out_a * 255)

    def fill_gradient(self, top: Color, bottom: Color) -> None:
        for y in range(self.height):
            t = y / max(1, self.height - 1)
            color = mix(top, bottom, t)
            for x in range(self.width):
                idx = (y * self.width + x) * 4
                self.pixels[idx : idx + 4] = bytes(color)

    def rounded_rect(
        self,
        x: float,
        y: float,
        w: float,
        h: float,
        r: float,
        top: Color,
        bottom: Color | None = None,
    ) -> None:
        bottom = bottom or top
        min_x = max(0, math.floor(x - 1))
        max_x = min(self.width, math.ceil(x + w + 1))
        min_y = max(0, math.floor(y - 1))
        max_y = min(self.height, math.ceil(y + h + 1))
        samples = ((0.25, 0.25), (0.75, 0.25), (0.25, 0.75), (0.75, 0.75))
        for py in range(min_y, max_y):
            t = (py - y) / max(1, h)
            color = mix(top, bottom, max(0.0, min(1.0, t)))
            for px in range(min_x, max_x):
                coverage = 0
                for ox, oy in samples:
                    sx = px + ox
                    sy = py + oy
                    qx = abs(sx - (x + w / 2)) - (w / 2 - r)
                    qy = abs(sy - (y + h / 2)) - (h / 2 - r)
                    outside = math.hypot(max(qx, 0), max(qy, 0))
                    inside = min(max(qx, qy), 0)
                    if outside + inside <= r:
                        coverage += 1
                if coverage:
                    self.blend_pixel(px, py, color, coverage / len(samples))

    def circle(self, cx: float, cy: float, radius: float, color: Color) -> None:
        min_x = max(0, math.floor(cx - radius - 1))
        max_x = min(self.width, math.ceil(cx + radius + 1))
        min_y = max(0, math.floor(cy - radius - 1))
        max_y = min(self.height, math.ceil(cy + radius + 1))
        for y in range(min_y, max_y):
            for x in range(min_x, max_x):
                dist = math.hypot(x + 0.5 - cx, y + 0.5 - cy)
                coverage = max(0.0, min(1.0, radius + 0.5 - dist))
                self.blend_pixel(x, y, color, coverage)

    def line(self, x1: float, y1: float, x2: float, y2: float, width: float, color: Color) -> None:
        radius = width / 2
        min_x = max(0, math.floor(min(x1, x2) - radius - 1))
        max_x = min(self.width, math.ceil(max(x1, x2) + radius + 1))
        min_y = max(0, math.floor(min(y1, y2) - radius - 1))
        max_y = min(self.height, math.ceil(max(y1, y2) + radius + 1))
        vx = x2 - x1
        vy = y2 - y1
        length_sq = vx * vx + vy * vy
        for y in range(min_y, max_y):
            for x in range(min_x, max_x):
                px = x + 0.5
                py = y + 0.5
                if length_sq == 0:
                    t = 0
                else:
                    t = max(0.0, min(1.0, ((px - x1) * vx + (py - y1) * vy) / length_sq))
                nx = x1 + t * vx
                ny = y1 + t * vy
                dist = math.hypot(px - nx, py - ny)
                coverage = max(0.0, min(1.0, radius + 0.5 - dist))
                self.blend_pixel(x, y, color, coverage)


def encode_png(width: int, height: int, pixels: bytes | bytearray) -> bytes:
    def chunk(kind: bytes, data: bytes) -> bytes:
        return (
            struct.pack(">I", len(data))
            + kind
            + data
            + struct.pack(">I", zlib.crc32(kind + data) & 0xFFFFFFFF)
        )

    raw = bytearray()
    row_len = width * 4
    for y in range(height):
        raw.append(0)
        raw.extend(pixels[y * row_len : (y + 1) * row_len])

    return (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(bytes(raw), 9))
        + chunk(b"IEND", b"")
    )


def write_png(path: Path, width: int, height: int, pixels: bytes | bytearray) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(encode_png(width, height, pixels))


def resize(src: Canvas, size: int) -> bytes:
    dst = bytearray(size * size * 4)
    scale_x = src.width / size
    scale_y = src.height / size
    for y in range(size):
        y0 = int(y * scale_y)
        y1 = max(y0 + 1, int((y + 1) * scale_y))
        for x in range(size):
            x0 = int(x * scale_x)
            x1 = max(x0 + 1, int((x + 1) * scale_x))
            totals = [0, 0, 0, 0]
            count = 0
            for sy in range(y0, min(src.height, y1)):
                for sx in range(x0, min(src.width, x1)):
                    idx = (sy * src.width + sx) * 4
                    totals[0] += src.pixels[idx]
                    totals[1] += src.pixels[idx + 1]
                    totals[2] += src.pixels[idx + 2]
                    totals[3] += src.pixels[idx + 3]
                    count += 1
            di = (y * size + x) * 4
            dst[di : di + 4] = bytes(round(v / count) for v in totals)
    return dst


def draw_mark(canvas: Canvas, scale: float = 1.0, offset_y: float = 0.0, with_glow: bool = True) -> None:
    s = min(canvas.width, canvas.height) * scale / 1024
    cx = canvas.width / 2
    cy = canvas.height / 2 + offset_y * s

    def tx(v: float) -> float:
        return cx + (v - 512) * s

    def ty(v: float) -> float:
        return cy + (v - 512) * s

    if with_glow:
        canvas.circle(cx, cy + 72 * s, 332 * s, (228, 213, 10, 32))
        canvas.circle(cx - 150 * s, cy - 172 * s, 138 * s, (255, 248, 113, 34))

    for i, alpha in enumerate((38, 28, 18)):
        grow = i * 22 * s
        canvas.rounded_rect(
            tx(184) - grow / 2,
            ty(288) - grow / 2 + i * 16 * s,
            656 * s + grow,
            454 * s + grow,
            122 * s,
            (0, 0, 0, alpha),
        )

    canvas.rounded_rect(
        tx(184),
        ty(276),
        656 * s,
        444 * s,
        116 * s,
        (242, 230, 42, 255),
        (111, 124, 0, 255),
    )
    canvas.rounded_rect(
        tx(254),
        ty(338),
        360 * s,
        58 * s,
        29 * s,
        (255, 255, 255, 64),
    )
    canvas.circle(tx(704), ty(482), 58 * s, (255, 255, 255, 42))
    canvas.circle(tx(704), ty(482), 30 * s, (255, 255, 255, 82))

    shadow = (40, 42, 18, 84)
    white = (255, 255, 255, 244)
    for dx, dy, color in ((7 * s, 10 * s, shadow), (0, 0, white)):
        canvas.line(tx(398) + dx, ty(410) + dy, tx(650) + dx, ty(410) + dy, 58 * s, color)
        canvas.line(tx(398) + dx, ty(492) + dy, tx(626) + dx, ty(492) + dy, 48 * s, color)
        canvas.line(tx(428) + dx, ty(410) + dy, tx(562) + dx, ty(410) + dy, 50 * s, color)
        canvas.line(tx(428) + dx, ty(410) + dy, tx(428) + dx, ty(716) + dy, 52 * s, color)
        canvas.line(tx(428) + dx, ty(540) + dy, tx(626) + dx, ty(716) + dy, 54 * s, color)


def icon_master() -> Canvas:
    canvas = Canvas(1024, 1024)
    canvas.fill_gradient((78, 74, 8, 255), (17, 18, 24, 255))
    canvas.circle(205, 160, 180, (228, 213, 10, 32))
    canvas.circle(875, 910, 280, (255, 255, 255, 14))
    draw_mark(canvas, scale=0.9, offset_y=14)
    return canvas


def splash_master(size: int) -> Canvas:
    canvas = Canvas(size, size)
    draw_mark(canvas, scale=0.86, with_glow=False)
    return canvas


def write_ico(path: Path, images: list[tuple[int, bytes]]) -> None:
    data = bytearray(struct.pack("<HHH", 0, 1, len(images)))
    offset = 6 + len(images) * 16
    for size, png in images:
        dim = 0 if size >= 256 else size
        data.extend(struct.pack("<BBBBHHII", dim, dim, 0, 0, 1, 32, len(png), offset))
        offset += len(png)
    for _, png in images:
        data.extend(png)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(bytes(data))


def png_bytes(size: int, canvas: Canvas) -> bytes:
    return encode_png(size, size, resize(canvas, size))


def main() -> None:
    icon = icon_master()
    write_png(ROOT / "assets" / "branding" / "flickpay_icon_1024.png", 1024, 1024, icon.pixels)

    android_sizes = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    for folder, size in android_sizes.items():
        write_png(
            ROOT / "android" / "app" / "src" / "main" / "res" / folder / "ic_launcher.png",
            size,
            size,
            resize(icon, size),
        )

    ios_files = {
        "Icon-App-20x20@1x.png": 20,
        "Icon-App-20x20@2x.png": 40,
        "Icon-App-20x20@3x.png": 60,
        "Icon-App-29x29@1x.png": 29,
        "Icon-App-29x29@2x.png": 58,
        "Icon-App-29x29@3x.png": 87,
        "Icon-App-40x40@1x.png": 40,
        "Icon-App-40x40@2x.png": 80,
        "Icon-App-40x40@3x.png": 120,
        "Icon-App-60x60@2x.png": 120,
        "Icon-App-60x60@3x.png": 180,
        "Icon-App-76x76@1x.png": 76,
        "Icon-App-76x76@2x.png": 152,
        "Icon-App-83.5x83.5@2x.png": 167,
        "Icon-App-1024x1024@1x.png": 1024,
    }
    ios_dir = ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    for filename, size in ios_files.items():
        write_png(ios_dir / filename, size, size, resize(icon, size))

    mac_files = {
        "app_icon_16.png": 16,
        "app_icon_32.png": 32,
        "app_icon_64.png": 64,
        "app_icon_128.png": 128,
        "app_icon_256.png": 256,
        "app_icon_512.png": 512,
        "app_icon_1024.png": 1024,
    }
    mac_dir = ROOT / "macos" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    for filename, size in mac_files.items():
        write_png(mac_dir / filename, size, size, resize(icon, size))

    web_files = {
        "favicon.png": 32,
        "icons/Icon-192.png": 192,
        "icons/Icon-maskable-192.png": 192,
        "icons/Icon-512.png": 512,
        "icons/Icon-maskable-512.png": 512,
    }
    for filename, size in web_files.items():
        write_png(ROOT / "web" / filename, size, size, resize(icon, size))

    ico_images = [(16, png_bytes(16, icon)), (32, png_bytes(32, icon)), (48, png_bytes(48, icon)), (256, png_bytes(256, icon))]
    write_ico(ROOT / "windows" / "runner" / "resources" / "app_icon.ico", ico_images)

    splash_sizes = {
        "mipmap-mdpi": 120,
        "mipmap-hdpi": 180,
        "mipmap-xhdpi": 240,
        "mipmap-xxhdpi": 360,
        "mipmap-xxxhdpi": 480,
    }
    for folder, size in splash_sizes.items():
        splash = splash_master(size)
        write_png(
            ROOT / "android" / "app" / "src" / "main" / "res" / folder / "launch_image.png",
            size,
            size,
            splash.pixels,
        )

    launch_dir = ROOT / "ios" / "Runner" / "Assets.xcassets" / "LaunchImage.imageset"
    for filename, size in {
        "LaunchImage.png": 180,
        "LaunchImage@2x.png": 360,
        "LaunchImage@3x.png": 540,
    }.items():
        splash = splash_master(size)
        write_png(launch_dir / filename, size, size, splash.pixels)


if __name__ == "__main__":
    os.chdir(ROOT)
    main()

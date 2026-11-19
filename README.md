# Adafruit NeoKey breakout enclosure

OpenSCAD design of a 2-part case for the NeoKey breakout board (Adafruit #4978).
The case is designed for a single JST S5B-XH-A connector soldered to the `IN` header as a cable entry.

The repository also contains Makefile and Dockerfile to compile STL's of the design.

Requirements:
- GNU Make
- Docker desktop

Compile the STLs by running:

```sh
make
```

Outputs:

- `build/stl/base.stl`, `build/stl/lid.stl` - plate oriented print-ready OpenSCAD exports of the parts.
- `build/preview/preview.png`, `build/preview/exploded.png` - rendering of the assembled case with mock breakout, MX switch base and connector.
- `build/preview/case.png` - shaded OpenSCAD views of case parts

For recommended FDM 3D printing parameters: see `neokey_argb_case.scad`

Assembly instructions:

1. Print the case base and lid parts
2. Place the JST connector in the entry hole
3. Place the breakout board in the cavity so the JST headers go through the holes
4. Solder the JST to the breakout, being careful not to damage the case
5. Place an MX compatible switch in the Kailh socket
6. Close the lid, the friction from the crush libs should secure it in place
7. Put an MX compatible keycap of choice
8. Connect to device of choice with a cable ending with a matching JST female header

For more details and screenshots checkout: https://www.printables.com/model/1921783-neokey-mx-switch-breakout-case

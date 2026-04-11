// ═══════════════════════════════════════════════════════════
//  modchart.hx  –  Test (Hard)
//  Ruta: mods/basegame/songs/test/modchart.hx
// ═══════════════════════════════════════════════════════════

function onCreate() {

    // ── Calcular desplazamiento Y para INVERT ─────────────────────────────────
    // INVERT solo invierte la dirección del scroll de las NOTAS.
    // Para que los strums (receptores) queden donde las notas llegan,
    // hay que moverlos manualmente con MOVE_Y al lado contrario.
    //
    // strumLineY ≈ 50  (upscroll, strums arriba)
    // strumLineY ≈ 670 (downscroll, strums abajo)
    // invertY = pantalla - 2*strumLineY  → desplazamiento al lado opuesto
    var strumY  = (noteManager != null) ? noteManager.strumLineY : 50.0;
    var screenH = FlxG.height;
    var ds      = (noteManager != null) ? noteManager.downscroll : false;
    var invertY = ds ? -(screenH - strumY * 2) : (screenH - strumY * 2);

    var mc = modChart;  // alias corto

    // ─────────────────────────────────────────────────────────
    //  INTRO (beats 0-31)
    // ─────────────────────────────────────────────────────────

    mc.addEventSimple(0,  "all", -1, DRUNK_X,    25, 32, QUAD_OUT);
    mc.addEventSimple(0,  "all", -1, DRUNK_FREQ, 0.8, 0, LINEAR);
    mc.addEventSimple(0,  "all", -1, SCROLL_MULT, 1.15, 4, QUAD_IN_OUT);
    mc.addEventSimple(4,  "all", -1, BEAT_SCALE, 0.08, 28, LINEAR);
    mc.addEventSimple(16, "all", -1, TIPSY,      30, 16, SINE_IN_OUT);
    mc.addEventSimple(28, "all", -1, TIPSY,       0,  4, QUAD_OUT);

    // ─────────────────────────────────────────────────────────
    //  PRIMERA RONDA (beats 32-63)
    // ─────────────────────────────────────────────────────────

    mc.addEventSimple(32, "all", -1, BUMPY,       50,  0, LINEAR);
    mc.addEventSimple(32, "all", -1, BUMPY_SPEED,  3,  0, LINEAR);
    mc.addEventSimple(32, "all", -1, DRUNK_X,     30,  4, QUAD_IN_OUT);

    // INVERT player: notas vienen del lado opuesto → strums se mueven también
    mc.addEventSimple(36, "player", -1, INVERT, 1,       0, LINEAR);
    mc.addEventSimple(36, "player", -1, MOVE_Y, invertY, 0, LINEAR);
    mc.addEventSimple(40, "player", -1, INVERT, 0, 0, LINEAR);
    mc.addEventSimple(40, "player", -1, MOVE_Y, 0, 2, QUAD_OUT);

    mc.addEventSimple(40, "all", -1, SCROLL_MULT, 2.0, 1, QUAD_IN);
    mc.addEventSimple(41, "all", -1, SCROLL_MULT, 1.1, 3, QUAD_OUT);

    mc.addEventSimple(44, "all", -1, TIPSY,  70, 4, SINE_IN_OUT);
    mc.addEventSimple(48, "all", -1, TIPSY,   0, 2, QUAD_OUT);

    mc.addEventSimple(48, "all", -1, ZIGZAG,      90, 4, QUAD_OUT);
    mc.addEventSimple(48, "all", -1, ZIGZAG_FREQ, 1.5, 0, LINEAR);
    mc.addEventSimple(52, "all", -1, ZIGZAG,       0, 2, QUAD_OUT);

    mc.addEventSimple(52, "all", -1, WAVE,       55, 4, QUAD_OUT);
    mc.addEventSimple(52, "all", -1, WAVE_SPEED,  2, 0, LINEAR);
    mc.addEventSimple(56, "all", -1, WAVE,        0, 2, QUAD_OUT);

    mc.addEventSimple(56, "all", -1, CONFUSION, 28, 4, LINEAR);
    mc.addEventSimple(60, "all", -1, CONFUSION,  0, 2, QUAD_OUT);
    mc.addEventSimple(60, "all", -1, BUMPY,      0, 2, QUAD_OUT);

    // ─────────────────────────────────────────────────────────
    //  ACORDES (beats 64-95)
    // ─────────────────────────────────────────────────────────

    mc.addEventSimple(64, "all", -1, DRUNK_X,  0, 2, QUAD_OUT);
    mc.addEventSimple(64, "all", -1, TORNADO, 28, 4, QUAD_OUT);
    mc.addEventSimple(68, "all", -1, TORNADO,  0, 2, QUAD_OUT);

    mc.addEventSimple(68, "all", -1, FLIP_X, 1, 0, LINEAR);
    mc.addEventSimple(72, "all", -1, FLIP_X, 0, 0, LINEAR);

    mc.addEventSimple(72, "all", -1, SCROLL_MULT, 2.2, 2, CUBE_IN);
    mc.addEventSimple(74, "all", -1, SCROLL_MULT, 1.0, 2, CUBE_OUT);

    mc.addEventSimple(76, "all", -1, BUMPY,       65, 4, QUAD_OUT);
    mc.addEventSimple(76, "all", -1, BUMPY_SPEED, 4.5, 0, LINEAR);
    mc.addEventSimple(80, "all", -1, BUMPY,        0, 2, QUAD_OUT);

    mc.addEventSimple(80, "all", -1, STEALTH, 0.65, 4, QUAD_IN_OUT);
    mc.addEventSimple(84, "all", -1, STEALTH,    0, 2, QUAD_OUT);

    mc.addEventSimple(84, "all", -1, TIPSY,  90, 4, SINE_IN_OUT);
    mc.addEventSimple(88, "all", -1, TIPSY,   0, 2, QUAD_OUT);

    mc.addEventSimple(88, "camera", -1, CAM_ZOOM, 0.25, 4, SINE_IN_OUT);
    mc.addEventSimple(92, "camera", -1, CAM_ZOOM,    0, 4, QUAD_OUT);

    // ─────────────────────────────────────────────────────────
    //  VELOCIDAD (beats 96-127)
    // ─────────────────────────────────────────────────────────

    mc.addEventSimple( 96, "all", -1, SCROLL_MULT, 1.7, 8, QUAD_IN_OUT);
    mc.addEventSimple( 96, "all", -1, DRUNK_Y,    45, 4, QUAD_OUT);
    mc.addEventSimple(100, "all", -1, DRUNK_Y,     0, 2, QUAD_OUT);

    mc.addEventSimple(100, "all", -1, ZIGZAG,      100, 4, QUAD_OUT);
    mc.addEventSimple(100, "all", -1, ZIGZAG_FREQ,   2, 0, LINEAR);
    mc.addEventSimple(104, "all", -1, ZIGZAG,        0, 2, QUAD_OUT);

    // INVERT player, strums player se mueven
    mc.addEventSimple(104, "player", -1, INVERT, 1,       0, LINEAR);
    mc.addEventSimple(104, "player", -1, MOVE_Y, invertY, 0, LINEAR);
    mc.addEventSimple(104, "cpu",    -1, SCROLL_MULT, 0.7, 4, QUAD_OUT);
    mc.addEventSimple(108, "player", -1, INVERT, 0, 0, LINEAR);
    mc.addEventSimple(108, "player", -1, MOVE_Y, 0, 2, QUAD_OUT);
    mc.addEventSimple(108, "cpu",    -1, SCROLL_MULT, 1.7, 2, QUAD_IN);

    mc.addEventSimple(108, "all", -1, CONFUSION, 38, 4, LINEAR);
    mc.addEventSimple(112, "all", -1, CONFUSION,  0, 2, QUAD_OUT);

    mc.addEventSimple(112, "all", -1, SCROLL_MULT, 2.6, 4, QUAD_IN);
    mc.addEventSimple(116, "all", -1, SCROLL_MULT, 1.0, 4, CUBE_OUT);

    // ─────────────────────────────────────────────────────────
    //  HOLDS GRANDES (beats 128-159)
    // ─────────────────────────────────────────────────────────

    mc.addEventSimple(128, "all", -1, WAVE,       65, 8, QUAD_OUT);
    mc.addEventSimple(128, "all", -1, WAVE_SPEED, 1.5, 0, LINEAR);
    mc.addEventSimple(128, "all", -1, BUMPY,      55, 4, QUAD_OUT);
    mc.addEventSimple(132, "all", -1, BUMPY,       0, 2, QUAD_OUT);
    mc.addEventSimple(136, "all", -1, WAVE,        0, 2, QUAD_OUT);

    mc.addEventSimple(136, "all", -1, TORNADO, 32, 4, QUAD_OUT);
    mc.addEventSimple(140, "all", -1, TORNADO,  0, 2, QUAD_OUT);

    mc.addEventSimple(144, "all", -1, SCROLL_MULT, 0.55, 2, CUBE_OUT);
    mc.addEventSimple(146, "all", -1, SCROLL_MULT, 2.0,  2, CUBE_IN);
    mc.addEventSimple(148, "all", -1, SCROLL_MULT, 1.0,  4, QUAD_OUT);

    mc.addEventSimple(148, "all", -1, TIPSY, 60, 4, SINE_IN_OUT);
    mc.addEventSimple(152, "all", -1, TIPSY,  0, 2, QUAD_OUT);

    mc.addEventSimple(152, "all", -1, NOTE_ALPHA, 0.4, 4, QUAD_IN_OUT);
    mc.addEventSimple(156, "all", -1, NOTE_ALPHA, 1.0, 2, QUAD_OUT);

    // ─────────────────────────────────────────────────────────
    //  PATRONES RÁPIDOS (beats 160-203)
    // ─────────────────────────────────────────────────────────

    mc.addEventSimple(160, "all", -1, DRUNK_X,    55, 8, QUAD_OUT);
    mc.addEventSimple(160, "all", -1, DRUNK_FREQ, 1.2, 0, LINEAR);

    mc.addEventSimple(164, "all", -1, CONFUSION, 32, 4, LINEAR);
    mc.addEventSimple(168, "all", -1, CONFUSION,  0, 2, QUAD_OUT);

    mc.addEventSimple(168, "all", -1, ZIGZAG,      75, 4, QUAD_OUT);
    mc.addEventSimple(168, "all", -1, ZIGZAG_FREQ, 1.8, 0, LINEAR);
    mc.addEventSimple(172, "all", -1, ZIGZAG,       0, 2, QUAD_OUT);

    mc.addEventSimple(172, "all", -1, TIPSY, 110, 4, SINE_IN_OUT);
    mc.addEventSimple(176, "all", -1, TIPSY,   0, 2, QUAD_OUT);

    mc.addEventSimple(176, "all", -1, SCROLL_MULT, 2.1, 4, QUAD_IN);
    mc.addEventSimple(180, "all", -1, SCROLL_MULT, 1.0, 2, QUAD_OUT);
    mc.addEventSimple(182, "all", -1, DRUNK_X,     0,   2, QUAD_OUT);

    mc.addEventSimple(184, "all", -1, BUMPY,       85, 4, QUAD_OUT);
    mc.addEventSimple(184, "all", -1, BUMPY_SPEED,  5, 0, LINEAR);
    mc.addEventSimple(188, "all", -1, BUMPY,        0, 2, QUAD_OUT);

    // INVERT alternado player/cpu, strums siguen en cada caso
    mc.addEventSimple(192, "player", -1, INVERT, 1,       0, LINEAR);
    mc.addEventSimple(192, "player", -1, MOVE_Y, invertY, 0, LINEAR);
    mc.addEventSimple(194, "player", -1, INVERT, 0, 0, LINEAR);
    mc.addEventSimple(194, "player", -1, MOVE_Y, 0, 1, QUAD_OUT);

    mc.addEventSimple(194, "cpu", -1, INVERT, 1,       0, LINEAR);
    mc.addEventSimple(194, "cpu", -1, MOVE_Y, invertY, 0, LINEAR);
    mc.addEventSimple(196, "cpu", -1, INVERT, 0, 0, LINEAR);
    mc.addEventSimple(196, "cpu", -1, MOVE_Y, 0, 1, QUAD_OUT);

    mc.addEventSimple(196, "all", -1, WAVE,       72, 4, QUAD_OUT);
    mc.addEventSimple(196, "all", -1, WAVE_SPEED, 2.5, 0, LINEAR);
    mc.addEventSimple(200, "all", -1, WAVE,        0,  2, QUAD_OUT);

    // ─────────────────────────────────────────────────────────
    //  CLÍMAX (beats 204-231)
    // ─────────────────────────────────────────────────────────

    mc.addEventSimple(204, "all",    -1, TORNADO,  42, 4, QUAD_OUT);
    mc.addEventSimple(204, "camera", -1, CAM_ZOOM, 0.3, 4, SINE_IN_OUT);
    mc.addEventSimple(208, "all",    -1, TORNADO,  0,  2, QUAD_OUT);
    mc.addEventSimple(208, "camera", -1, CAM_ZOOM, 0,  2, QUAD_OUT);

    mc.addEventSimple(208, "all", -1, CONFUSION, 50, 4, LINEAR);
    mc.addEventSimple(212, "all", -1, CONFUSION,  0, 2, QUAD_OUT);

    mc.addEventSimple(212, "all", -1, SCROLL_MULT, 2.6, 2, CUBE_IN);
    mc.addEventSimple(214, "all", -1, SCROLL_MULT, 0.7, 2, CUBE_OUT);
    mc.addEventSimple(216, "all", -1, SCROLL_MULT, 1.8, 4, QUAD_IN_OUT);
    mc.addEventSimple(220, "all", -1, SCROLL_MULT, 1.0, 2, QUAD_OUT);

    mc.addEventSimple(220, "all", -1, ZIGZAG, 85, 4, QUAD_OUT);
    mc.addEventSimple(220, "all", -1, WAVE,   55, 4, QUAD_OUT);
    mc.addEventSimple(224, "all", -1, ZIGZAG,  0, 2, QUAD_OUT);
    mc.addEventSimple(224, "all", -1, WAVE,    0, 2, QUAD_OUT);

    mc.addEventSimple(224, "all", -1, DRUNK_X, 65, 4, QUAD_OUT);
    mc.addEventSimple(224, "all", -1, DRUNK_Y, 35, 4, QUAD_OUT);
    mc.addEventSimple(228, "all", -1, DRUNK_X,  0, 2, QUAD_OUT);
    mc.addEventSimple(228, "all", -1, DRUNK_Y,  0, 2, QUAD_OUT);

    // INVERT todos: momento final del clímax, strums de ambos lados se mueven
    mc.addEventSimple(228, "all", -1, INVERT, 1,       0, LINEAR);
    mc.addEventSimple(228, "all", -1, MOVE_Y, invertY, 0, LINEAR);
    mc.addEventSimple(232, "all", -1, INVERT, 0, 0, LINEAR);
    mc.addEventSimple(232, "all", -1, MOVE_Y, 0, 2, QUAD_OUT);

    // ─────────────────────────────────────────────────────────
    //  OUTRO (beats 232-271)
    // ─────────────────────────────────────────────────────────

    mc.addEventSimple(232, "all", -1, SCROLL_MULT, 1.3, 8, QUAD_IN_OUT);

    mc.addEventSimple(236, "all", -1, TIPSY,  45, 4, SINE_IN_OUT);
    mc.addEventSimple(240, "all", -1, TIPSY,   0, 4, QUAD_OUT);

    mc.addEventSimple(240, "all", -1, BUMPY,       35, 8, QUAD_OUT);
    mc.addEventSimple(240, "all", -1, BUMPY_SPEED, 2.5, 0, LINEAR);
    mc.addEventSimple(248, "all", -1, BUMPY,        0,  4, QUAD_OUT);

    mc.addEventSimple(248, "all", -1, STEALTH, 0.5, 4, QUAD_IN_OUT);
    mc.addEventSimple(252, "all", -1, STEALTH,   0, 4, QUAD_OUT);

    mc.addEventSimple(256, "all", -1, SCROLL_MULT, 1.0, 4, QUAD_OUT);
    mc.addEventSimple(260, "all", -1, DRUNK_X,       0, 4, QUAD_OUT);
    mc.addEventSimple(264, "all", -1, BEAT_SCALE,    0, 4, QUAD_OUT);

    // Limpieza total al final
    mc.addEventSimple(268, "all", -1, MOVE_Y, 0, 2, QUAD_OUT);
    mc.addEventSimple(268, "all", -1, MOVE_X, 0, 2, QUAD_OUT);
}

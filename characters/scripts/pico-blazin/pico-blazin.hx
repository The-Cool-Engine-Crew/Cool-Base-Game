/**
 * pico-blazin — CharacterScript
 * Puerto de V-Slice (pico-blazin.hxc) al engine
 *
 * Ruta:  mods/{mod}/characters/scripts/pico-blazin/scripts.hx
 *    o:  assets/characters/scripts/pico-blazin/scripts.hx
 *
 * Pico es el JUGADOR (boyfriend). Sus notas las golpea el humano,
 * por lo que las reacciones llegan via onPlayerNoteHit() y onPlayerNoteMiss().
 *
 * NOTA V-Slice omitida:
 *   GameOverSubState.musicSuffix / PauseSubState.musicSuffix
 *   → En este engine configura la música de game over desde el JSON
 *     del personaje (campos gameOverSound / gameOverMusic / gameOverEnd).
 */

// ── Estado interno ────────────────────────────────────────────────────────────

var cantUppercut:Bool = false;
var alternate:Bool    = false;

// ── Lifecycle ─────────────────────────────────────────────────────────────────

function onCreate() {
    character.holdTimer = 0;
}

function postCreate() {
    character.playAnim('idle', false);
}

var isDance:Bool = false;

// Cancela el idle/dance automático del engine (equivale a danceEvery = 0 en V-Slice)
function overrideDance():Bool {

    if (!isDance)
        return true;
    else
        return false;
}

// Reinicio de canción → resetear estado y volver al idle
function onSongStart() {
    cantUppercut = false;
    character.playAnim('idle', true);
}

// ── Callbacks de notas ────────────────────────────────────────────────────────

/**
 * Llamado cuando Pico (player) golpea una nota.
 * Equivale a onNoteHit() del script V-Slice de Pico.
 * args: (note, rating:String)
 */
function onPlayerNoteHit(note, rating) {
    character.holdTimer = 0;

    if (!StringTools.startsWith(note.noteType, 'weekend-1-')) return;

    scripts.call('onPicoNoteHit', [note]);

    // Caso especial: Pico golpeó mal con poca salud y Darnell está
    // preparando un uppercut → Pico sigue con punchHigh igualmente
    var shouldDoUppercutPrep = wasNoteHitPoorly(note) && isPlayerLowHealth() && isDarnellPreppingUppercut();
    if (shouldDoUppercutPrep) {
        playPunchHighAnim();
        return;
    }

    if (cantUppercut) {
        playBlockAnim();
        cantUppercut = false;
        return;
    }

    switch (note.noteType) {
        case "weekend-1-punchlow":        playPunchLowAnim();
        case "weekend-1-punchlowblocked": playPunchLowAnim();
        case "weekend-1-punchlowdodged":  playPunchLowAnim();
        case "weekend-1-punchlowspin":    playPunchLowAnim();

        case "weekend-1-punchhigh":        playPunchHighAnim();
        case "weekend-1-punchhighblocked": playPunchHighAnim();
        case "weekend-1-punchhighdodged":  playPunchHighAnim();
        case "weekend-1-punchhighspin":    playPunchHighAnim();

        case "weekend-1-blockhigh": playBlockAnim();
        case "weekend-1-blocklow":  playBlockAnim();
        case "weekend-1-blockspin": playBlockAnim();

        case "weekend-1-dodgehigh": playDodgeAnim();
        case "weekend-1-dodgelow":  playDodgeAnim();
        case "weekend-1-dodgespin": playDodgeAnim();

        // Pico siempre recibe el golpe
        case "weekend-1-hithigh":    playHitHighAnim();
        case "weekend-1-hitlow":     playHitLowAnim();
        case "weekend-1-hitspin":    playHitSpinAnim();

        // Uppercut de Pico
        case "weekend-1-picouppercutprep": playUppercutPrepAnim();
        case "weekend-1-picouppercut":     playUppercutAnim(true);

        // Uppercut de Darnell
        case "weekend-1-darnelluppercutprep": playIdleAnim();
        case "weekend-1-darnelluppercut":     playUppercutHitAnim();

        case "weekend-1-idle":           playIdleAnim();
        case "weekend-1-fakeout":        playFakeoutAnim();
        case "weekend-1-taunt":          playTauntConditionalAnim();
        case "weekend-1-tauntforce":     playTauntAnim();
        case "weekend-1-reversefakeout": playIdleAnim();
    }
}

function onBeatHit(beat:Int) {
    if (beat % 8 == 0 && !isDance) {
        isDance = true;
    }
    else
        isDance = false;
}

/**
 * Llamado cuando Pico (player) falla una nota.
 * Equivale a onNoteMiss() del script V-Slice de Pico.
 * args: (note, extra)
 */
function onPlayerNoteMiss(note) {
    character.holdTimer = 0;

    scripts.call('onPicoMissed', [note]);

    // Caso especial: Darnell está en uppercut y Pico falló → recibe el golpe
    if (isDarnellInUppercut()) {
        playUppercutHitAnim();
        return;
    }

    if (willMissBeLethal()) {
        playHitLowAnim();
        return;
    }

    if (cantUppercut) {
        playHitHighAnim();
        cantUppercut = false;
        return;
    }

    if (!StringTools.startsWith(note.noteType, 'weekend-1-')) return;

    switch (note.noteType) {
        case "weekend-1-punchlow":        playHitLowAnim();
        case "weekend-1-punchlowblocked": playHitLowAnim();
        case "weekend-1-punchlowdodged":  playHitLowAnim();
        case "weekend-1-punchlowspin":    playHitSpinAnim();

        case "weekend-1-punchhigh":        playHitHighAnim();
        case "weekend-1-punchhighblocked": playHitHighAnim();
        case "weekend-1-punchhighdodged":  playHitHighAnim();
        case "weekend-1-punchhighspin":    playHitSpinAnim();

        case "weekend-1-blockhigh":  playHitHighAnim();
        case "weekend-1-blocklow":   playHitLowAnim();
        case "weekend-1-blockspin":  playHitSpinAnim();

        case "weekend-1-dodgehigh":  playHitHighAnim();
        case "weekend-1-dodgelow":   playHitLowAnim();
        case "weekend-1-dodgespin":  playHitSpinAnim();

        case "weekend-1-hithigh":    playHitHighAnim();
        case "weekend-1-hitlow":     playHitLowAnim();
        case "weekend-1-hitspin":    playHitSpinAnim();

        // Pico falló en esquivar el uppercut → queda expuesto
        case "weekend-1-picouppercutprep":
            playPunchHighAnim();
            cantUppercut = true;
        case "weekend-1-picouppercut":
            playUppercutAnim(false);

        case "weekend-1-darnelluppercutprep": playIdleAnim();
        case "weekend-1-darnelluppercut":     playUppercutHitAnim();

        case "weekend-1-idle":           playIdleAnim();
        case "weekend-1-fakeout":        playHitHighAnim();
        case "weekend-1-taunt":          playTauntConditionalAnim();
        case "weekend-1-tauntforce":     playTauntAnim();
        case "weekend-1-reversefakeout": playIdleAnim();
    }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/**
 * Devuelve true si el golpe tuvo mala calificación (bad/shit).
 * En V-Slice: event.judgement == "bad" || "shit"
 * En este engine: note.noteRating
 */
function wasNoteHitPoorly(note):Bool {
    return (note.noteRating == 'bad' || note.noteRating == 'shit');
}

/**
 * Aproximación de willMissBeLethal.
 * V-Slice usaba event.healthChange; aquí estimamos el drain por miss.
 */
function willMissBeLethal():Bool {
    // Drain típico por miss ≈ 0.1~0.15 HP (ajusta según tu config)
    return game != null && (game.health <= 0.15);
}

function isPlayerLowHealth():Bool {
    return game != null && (game.health <= 0.30 * 2.0);
}

function getDarnell() {
    if (character.debugMode || game == null) return null;
    return game.dad;
}

function isDarnellPreppingUppercut():Bool {
    var darnell = getDarnell();
    if (darnell == null) return false;
    return darnell.getCurAnimName() == 'uppercutPrep';
}

function isDarnellInUppercut():Bool {
    var darnell = getDarnell();
    if (darnell == null) return false;
    var anim = darnell.getCurAnimName();
    return anim == 'uppercut' || anim == 'uppercut-hold';
}

function doAlternate():String {
    alternate = !alternate;
    return alternate ? '1' : '2';
}

// ── Helpers de capa (zIndex) ──────────────────────────────────────────────────
// NOTA: Este engine no usa zIndex para orden de render en runtime.
// El orden lo define la posición del personaje en el array del stage JSON.
function moveToBack() {
    // En el script de Pico, queremos ponernos detrás de Darnell (dad)
    addBehindChar(character, dad);
}

function moveToFront() {
    // Ponernos delante de Darnell
    addInFrontOfChar(character, dad);
}

// ── Funciones de animación ────────────────────────────────────────────────────

function playBlockAnim() {
    character.playAnim('block', true);
    if (game != null) game.camGame.shake(0.002, 0.1);
    moveToBack();
}

function playDodgeAnim() {
    character.playAnim('dodge', true);
    moveToBack();
}

function playIdleAnim() {
    character.playAnim('idle', false);
    moveToBack();
}

function playFakeoutAnim() {
    character.playAnim('fakeout', true);
    moveToBack();
}

function playUppercutPrepAnim() {
    character.playAnim('uppercutPrep', true);
    moveToFront();
}

/**
 * @param hit  true si el uppercut conectó (agrega shake de cámara)
 */
function playUppercutAnim(hit:Bool) {
    character.playAnim('uppercut', true);
    if (hit && game != null) game.camGame.shake(0.005, 0.25);
    moveToFront();
}

function playUppercutHitAnim() {
    character.playAnim('uppercutHit', true);
    if (game != null) game.camGame.shake(0.005, 0.25);
    moveToBack();
}

function playHitHighAnim() {
    character.playAnim('hitHigh', true);
    if (game != null) game.camGame.shake(0.0025, 0.15);
    moveToBack();
}

function playHitLowAnim() {
    character.playAnim('hitLow', true);
    if (game != null) game.camGame.shake(0.0025, 0.15);
    moveToBack();
}

function playHitSpinAnim() {
    // V-Slice usaba reversed=true en este anim; aquí se pasa reversed al 4.º arg
    character.playAnim('hitSpin', true, true);
    if (game != null) game.camGame.shake(0.0025, 0.15);
    moveToBack();
}

function playPunchHighAnim() {
    var postfix:String = doAlternate();
    character.playAnim('punchHigh' + postfix, true);
    moveToFront();
}

function playPunchLowAnim() {
    var postfix:String = doAlternate();
    character.playAnim('punchLow' + postfix, true);
    moveToFront();
}

function playTauntConditionalAnim() {
    if (character.getCurAnimName() == 'fakeout')
        playTauntAnim();
    else
        playIdleAnim();
}

function playTauntAnim() {
    character.playAnim('taunt', true);
    moveToBack();
}

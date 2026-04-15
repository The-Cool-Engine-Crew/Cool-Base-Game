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
 * Llamado cuando el CPU (Darnell) golpea una nota.
 * Equivale a onNoteHit() en el script V-Slice de Darnell.
 * Nota: el CPU siempre golpea perfectamente, así que
 * wasNoteHitPoorly() siempre sería false aquí → se omite ese bloque.
 */
function onPicoNoteHit(note) {
    character.holdTimer = 0;

    if (!StringTools.startsWith(note.noteType, 'weekend-1-')) return;

    if (cantUppercut) {
        playPunchHighAnim();
        cantUppercut = false;
        return;
    }

    switch (note.noteType) {
        // Pico ataca bajo
        case "weekend-1-punchlow":        playHitLowAnim();
        case "weekend-1-punchlowblocked": playBlockAnim();
        case "weekend-1-punchlowdodged":  playDodgeAnim();
        case "weekend-1-punchlowspin":    playSpinAnim();

        // Pico ataca alto
        case "weekend-1-punchhigh":        playHitHighAnim();
        case "weekend-1-punchhighblocked": playBlockAnim();
        case "weekend-1-punchhighdodged":  playDodgeAnim();
        case "weekend-1-punchhighspin":    playSpinAnim();

        // Darnell contraataca (Pico bloquea/esquiva/recibe)
        case "weekend-1-blockhigh":  playPunchHighAnim();
        case "weekend-1-blocklow":   playPunchLowAnim();
        case "weekend-1-blockspin":  playPunchHighAnim();

        case "weekend-1-dodgehigh":  playPunchHighAnim();
        case "weekend-1-dodgelow":   playPunchLowAnim();
        case "weekend-1-dodgespin":  playPunchHighAnim();

        case "weekend-1-hithigh":    playPunchHighAnim();
        case "weekend-1-hitlow":     playPunchLowAnim();
        case "weekend-1-hitspin":    playPunchHighAnim();

        // Uppercut de Pico
        case "weekend-1-picouppercutprep":
            // Continuar la animación actual; Darnell no reacciona aquí
        case "weekend-1-picouppercut":
            playUppercutHitAnim();

        // Uppercut de Darnell
        case "weekend-1-darnelluppercutprep": playUppercutPrepAnim();
        case "weekend-1-darnelluppercut":     playUppercutAnim();

        // Miscelánea
        case "weekend-1-idle":          playIdleAnim();
        case "weekend-1-fakeout":       playCringeAnim();
        case "weekend-1-taunt":         playPissedConditionalAnim();
        case "weekend-1-tauntforce":    playPissedAnim();
        case "weekend-1-reversefakeout": playFakeoutAnim();
    }

    cantUppercut = false;
}

/**
 * Llamado cuando Pico (player) falla una nota.
 * Equivale a onNoteMiss() del script V-Slice de Darnell.
 * Nota: args = (note, extra) — usamos note.noteType.
 */
function onPicoMissed(note) {
    character.holdTimer = 0;

    if (!StringTools.startsWith(note.noteType, 'weekend-1-')) return;

    // Caso especial: Darnell preparó uppercut y Pico falló → ¡a rematar!
    if (character.getCurAnimName() == 'uppercutPrep') {
        playUppercutAnim();
        return;
    }

    // Si el miss mata al jugador, Darnell golpea bajo
    if (willMissBeLethal()) {
        playPunchLowAnim();
        return;
    }

    if (cantUppercut) {
        playPunchHighAnim();
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

        case "weekend-1-blockhigh":  playPunchHighAnim();
        case "weekend-1-blocklow":   playPunchLowAnim();
        case "weekend-1-blockspin":  playPunchHighAnim();

        case "weekend-1-dodgehigh":  playPunchHighAnim();
        case "weekend-1-dodgelow":   playPunchLowAnim();
        case "weekend-1-dodgespin":  playPunchHighAnim();

        case "weekend-1-hithigh":    playPunchHighAnim();
        case "weekend-1-hitlow":     playPunchLowAnim();
        case "weekend-1-hitspin":    playPunchHighAnim();

        // Pico esquivó el uppercut de Darnell → Darnell bloqueado
        case "weekend-1-picouppercutprep":
            playHitHighAnim();
            cantUppercut = true;
        case "weekend-1-picouppercut":
            playDodgeAnim();

        case "weekend-1-darnelluppercutprep": playUppercutPrepAnim();
        case "weekend-1-darnelluppercut":     playUppercutAnim();

        case "weekend-1-idle":          playIdleAnim();
        case "weekend-1-fakeout":       playCringeAnim();
        case "weekend-1-taunt":         playPissedConditionalAnim();
        case "weekend-1-tauntforce":    playPissedAnim();
        case "weekend-1-reversefakeout": playFakeoutAnim();
    }

    cantUppercut = false;
}

function onBeatHit(beat:Int) {
    if (beat % 8 == 0 && !isDance) {
        isDance = true;
    }
    else
        isDance = false;
}

function onPlayerNoteHit(note) {
    // Evitar sobreescribir si ya está preparando el uppercut
    if (character.getCurAnimName() == 'uppercutPrep') return;

    // Ajusta la lectura del rating según tu engine (puede ser note.rating o el argumento directo)
    var isPoorHit = (note.noteRating == 'bad' || note.noteRating == 'shit'); 
    
    var shouldDoUppercutPrep = isPoorHit && isPlayerLowHealth() && FlxG.random.bool(30);
    
    if (shouldDoUppercutPrep) {
        playUppercutPrepAnim();
    }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/**
 * Aproximación de willMissBeLethal: true si la salud es tan baja
 * que el próximo miss la llevaría a 0.
 * (V-Slice usaba event.healthChange; aquí estimamos el drain por miss.)
 */
function willMissBeLethal():Bool {
    // Drain típico por miss ≈ 0.1~0.15 HP (ajusta según tu config)
    return game != null && (game.health <= 0.15);
}

function isPlayerLowHealth():Bool {
    return game != null && (game.health <= 0.30 * 2.0);
}

function doAlternate():String {
    alternate = !alternate;
    return alternate ? '1' : '2';
}

// ── Helpers de capa (zIndex)  ─────────────────────────────────────────────────
// NOTA: Este engine no usa zIndex para orden de render — el orden lo define
// la posición del personaje en el array del stage JSON.
// Si necesitas que Darnell aparezca delante/detrás, edita el stage.
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

function playCringeAnim() {
    character.playAnim('cringe', true);
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

function playPissedConditionalAnim() {
    if (character.getCurAnimName() == 'cringe')
        playPissedAnim();
    else
        playIdleAnim();
}

function playPissedAnim() {
    character.playAnim('pissed', true);
    moveToBack();
}

function playUppercutPrepAnim() {
    character.playAnim('uppercutPrep', true);
    moveToFront();
}

function playUppercutAnim() {
    character.playAnim('uppercut', true);
    moveToFront();
}

function playUppercutHitAnim() {
    character.playAnim('uppercutHit', true);
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

function playSpinAnim() {
    character.playAnim('hitSpin', true);
    if (game != null) game.camGame.shake(0.0025, 0.15);
    moveToBack();
}

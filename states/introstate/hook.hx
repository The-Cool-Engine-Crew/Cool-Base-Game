import funkin.scripting.ScriptableState;

function onFinish() {
    switchStateInstance(new ScriptableState('touchtoplay'));
    return true;
}

function onSkip() {
    return true;
}

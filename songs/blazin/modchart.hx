function onCreate() {
	var mc = modChart; // alias corto

	mc.addEventSimple(1, "cpu", -1, ALPHA, 0, 0, INSTANT);

	mc.addEventSimple(1, "player", -1, MOVE_X, -300, 0, INSTANT);
}

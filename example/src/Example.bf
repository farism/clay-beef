using System;
using static RaylibBeef.Raylib;

namespace example;

static class Example
{
#if BF_PLATFORM_WASM
	[CLink, CallingConvention(.Stdcall)]
	private static extern void emscripten_set_main_loop(function void() func, int32 fps, int32 simulateInfinteLoop);

	[CLink, CallingConvention(.Stdcall)]
	private static extern int32 emscripten_set_main_loop_timing(int32 mode, int32 value);

	[CLink, CallingConvention(.Stdcall)]
	private static extern double emscripten_get_now();

	private static void EmscriptenMainLoop()
	{
		Render();
	}
#endif

	public static void Init()
	{
		SetTargetFPS(60);
		SetConfigFlags(RaylibBeef.ConfigFlags.FlagMsaa4XHint);
		InitWindow(1366, 768, scope $"Clay Beef");
		SetWindowState(.FlagWindowResizable);

		ClayHomepage.Init();

#if BF_PLATFORM_WASM
		emscripten_set_main_loop(=> EmscriptenMainLoop, 0, 1);
#else
		while (!WindowShouldClose())
		{
			Render();
		}
#endif
	}

	static void Render()
	{
		BeginDrawing();

		ClearBackground(RAYWHITE);

		let mousePos = GetMousePosition();
		let mouseWheel = GetMouseWheelMoveV();

		ClayHomepage.Update(mousePos.x, mousePos.y, mouseWheel.x, mouseWheel.y, IsMouseButtonDown(.MouseButtonLeft));

		EndDrawing();
	}

	static int Main(params String[] args)
	{
		Example.Init();

		return 0;
	}
}
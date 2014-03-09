import FreeImage

when isMainModule:
  proc main() =
    var bitmap = FreeImage_Load(FIF_PNG, "OwlAlpha.png", PNG_DEFAULT)
    var info = FreeImage_GetInfoHeader(bitmap)
    echo repr(info)
    FreeImage_Unload(bitmap)

  main()

{
  config,
  uthash,
  lib,
  stdenv,
  nv-codec-headers-12,
  fetchFromGitHub,
  fetchpatch,
  addDriverRunpath,
  cmake,
  fdk_aac,
  ffmpeg,
  jansson,
  libjack2,
  libxkbcommon,
  libpthreadstubs,
  libXdmcp,
  qtbase,
  qtsvg,
  speex,
  libv4l,
  x264,
  curl,
  wayland,
  xorg,
  pkg-config,
  libvlc,
  libGL,
  mbedtls,
  wrapGAppsHook3,
  scriptingSupport ? true,
  luajit,
  swig,
  python3,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  pciutils,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  withFdk ? true,
  pipewire,
  libdrm,
  librist,
  libva,
  srt,
  qtwayland,
  wrapQtAppsHook,
  nlohmann_json,
  websocketpp,
  asio,
  decklinkSupport ? false,
  blackmagic-desktop-video,
  libdatachannel,
  libvpl,
  qrcodegencpp,
  nix-update-script,
}:

let
  inherit (lib) optional optionals;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-studio";
  version = "30.2.3";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    rev = finalAttrs.version;
    hash = "sha256-4bAzW62xX9apKOAJyn3iys1bFdHj4re2reMZtlGsn5s=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  patches = [
    # Lets obs-browser build against CEF 90.1.0+
    #./Enable-file-access-and-universal-access-for-file-URL.patch
    ./fix-nix-plugin-path.patch

    # Fix libobs.pc for plugins on non-x86 systems
    (fetchpatch {
      name = "fix-arm64-cmake.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/obs-studio/broken-config.patch?id=a92887564dcc65e07b6be8a6224fda730259ae2b";
      hash = "sha256-yRSw4VWDwMwysDB3Hw/tsmTjEQUhipvrVRQcZkbtuoI=";
      includes = [ "*/CompilerConfig.cmake" ];
    })

    (fetchpatch {
      name = "qt-6.8.patch";
      url = "https://github.com/obsproject/obs-websocket/commit/d9befb9e0a4898695eef5ccbc91a4fac02027854.patch";
      extraPrefix = "plugins/obs-websocket/";
      stripLen = 1;
      hash = "sha256-7SDBRr9G40b9DfbgdaYJxTeiDSLUfVixtMtM3cLTVZs=";
    })

    # Fix lossless audio, ffmpeg 7,1 compatibility issue
    (fetchpatch {
      name = "fix-lossless-audio.patch";
      url = "https://github.com/obsproject/obs-studio/commit/dfc3a69c5276edf84c933035ff2a7e278fa13c9a.patch";
      hash = "sha256-wiF3nolBpZKp7LR7NloNfJ+v4Uq/nBgwCVoKZX+VEMA=";
    })
  ];

  nativeBuildInputs = [
    addDriverRunpath
    cmake
    pkg-config
    wrapGAppsHook3
    wrapQtAppsHook
  ] ++ optional scriptingSupport swig;

  buildInputs =
    [
      curl
      ffmpeg
      jansson
      libjack2
      libv4l
      libxkbcommon
      libpthreadstubs
      libXdmcp
      qtbase
      qtsvg
      speex
      wayland
      x264
      libvlc
      mbedtls
      pciutils
      librist
      libva
      srt
      qtwayland
      nlohmann_json
      websocketpp
      asio
      libdatachannel
      libvpl
      qrcodegencpp
      uthash
      nv-codec-headers-12
    ]
    ++ optionals scriptingSupport [
      luajit
      python3
    ]
    ++ optional alsaSupport alsa-lib
    ++ optional pulseaudioSupport libpulseaudio
    ++ optionals pipewireSupport [
      pipewire
      libdrm
    ]
    ++ optional withFdk fdk_aac;

  cmakeFlags = [
    "-DOBS_VERSION_OVERRIDE=${finalAttrs.version}"
    "-Wno-dev" # kill dev warnings that are useless for packaging
    "-DBUILD_BROWSER=OFF"
    "-DENABLE_JACK=ON"
    (lib.cmakeBool "ENABLE_QSV11" stdenv.hostPlatform.isx86_64)
    (lib.cmakeBool "ENABLE_LIBFDK" withFdk)
    (lib.cmakeBool "ENABLE_ALSA" alsaSupport)
    (lib.cmakeBool "ENABLE_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "ENABLE_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "ENABLE_AJA" false) # TODO: fix linking against libajantv2
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=sign-compare" # https://github.com/obsproject/obs-studio/issues/10200
    "-Wno-error=stringop-overflow="
  ];

  dontWrapGApps = true;
  preFixup =
    let
      wrapperLibraries =
        [
          xorg.libX11
          libvlc
          libGL
        ]
        ++ optionals decklinkSupport [
          blackmagic-desktop-video
        ];
    in
    ''
      # Remove libcef before patchelf, otherwise it will fail
      #rm $out/lib/obs-plugins/libcef.so

      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath wrapperLibraries}"
        ''${gappsWrapperArgs[@]}
      )
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    addDriverRunpath $out/lib/lib*.so
    addDriverRunpath $out/lib/obs-plugins/*.so

  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    maintainers = with maintainers; [
      jb55
      materus
      fpletz
    ];
    license = with licenses; [ gpl2Plus ] ++ optional withFdk fraunhofer-fdk;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
    mainProgram = "obs";
  };
})

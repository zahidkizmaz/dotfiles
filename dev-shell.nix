{ pkgs }: {
  default = pkgs.mkShell {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    packages = with pkgs; [
      nixd
      nixpkgs-fmt
    ];
  };
}

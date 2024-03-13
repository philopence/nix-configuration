# Shell for bootstrapping flake-enabled nix and home-manager
# You can enter it through 'nix develop' or (legacy) 'nix-shell'

{ pkgs ? (import ./nixpkgs.nix) { } }: {
  default = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [ nix home-manager git ];
  };
  secret = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [ nix home-manager git sops age ssh-to-age ssh-to-pgp ];
  };
  prisma = pkgs.mkShell {
    shellHook = with pkgs; ''
      export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
      export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
      export PRISMA_SCHEMA_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
      export PRISMA_MIGRATION_ENGINE_BINARY="${prisma-engines}/bin/migration-engine"
      export PRISMA_INTROSPECTION_ENGINE_BINARY="${prisma-engines}/bin/introspection-engine"
    '';
  };
}

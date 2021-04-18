# 雙峰祭オンラインシステム バックエンド インフラ

[![CI](https://github.com/sohosai/sos21-backend-infrastructure/actions/workflows/ci.yml/badge.svg)](https://github.com/sohosai/sos21-backend-infrastructure/actions/workflows/ci.yml)

## Requirements

- [Nix](https://nixos.org/nix/)
- FUSE (needs `fusermount`)

## Apply

1. `main` に対してプルリクエストを作成します。
2. `/plan` とコメントすると、plan を生成してコメントに表示します。
3. `/apply` とコメントすると、その plan を適用した後にプルリクエストを `main` にマージします。

## Development

`nix-shell` 内で開発に必要なツールが利用可能です。

```shell
$ nix-shell
$ terraform init
$ terraform apply
```

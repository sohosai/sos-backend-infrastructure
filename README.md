# 雙峰祭オンラインシステム バックエンド インフラ

[![CI](https://github.com/sohosai/sos22-backend-infrastructure/actions/workflows/ci.yml/badge.svg)](https://github.com/sohosai/sos22-backend-infrastructure/actions/workflows/ci.yml)

## Requirements

- [Nix](https://nixos.org/nix/)
- FUSE (needs `fusermount`)

## Development

`nix-shell` 内で開発に必要なツールが利用可能です。

```shell
$ nix-shell
$ terraform init
$ terraform apply
```

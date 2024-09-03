# Trillium / Fairis

Trillium is a higher-order concurrent separation logic for proving trace
refinements between programs and models. The logic is
built using the [Iris](https://iris-project.org) program logic framework and
mechanized in the [Coq proof assistant](https://coq.inria.fr/).

## Directory Structure

- [`trillium/`](trillium/): The Trillium program logic framework

- [`fairis/`](fairis/): The Fairis instantiation of Trillium for reasoning
  about fair termination of concurrent programs.
  + [`heap_lang/`](fairis/heap_lang/): HeapLang instantiation with fuel model
    * [`examples/`](fairis/heap_lang/examples/): Examples and case studies

## Compiling

`trillium` is a Nix flake and as such you can
- run `nix build` to build `trillium`,
- run `nix develop` to enter a development shell with all dependencies available to develop `trillium` or
- load `trillium` as a flake input to use it as a library (see the flake in [Aneris](https://github.com/logsem/aneris/blob/master/flake.nix) as an example). 

### Nix installation

This is performed only once.
1. [Install Nix](https://nix.dev/install-nix.html) with `curl -L https://nixos.org/nix/install | sh -s -- --daemon`
2. Enable [flake support](https://nixos.wiki/wiki/Flakes) with `mkdir -p ~/.config/nix && echo -e "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`
All set.


## Publications

The [POPL 2024 paper](https://iris-project.org/pdfs/2024-popl-trillium.pdf) is
available describing Trillium, a program logic framework for both proving
partial correctness properties and trace properties; [Aneris](https://github.com/logsem/aneris) 
is now an instantiation of the Trillium framework.

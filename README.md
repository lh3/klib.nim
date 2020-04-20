klib.nim implements the following functionality in one file:

* Unix-like `getopt` and `getopt_long` with Python-like APIs. Adapted from `ketopt.h`.
* A gzip file reader that also seamlessly works with ordinary files.
* A FASTA/FASTQ parser based on `kseq.h`.
* Fast interval queries based on implicit augmented interval trees. Based on cgranges.

klib.nim is my weekend project to learn the basic of nim. I am not sure if I
will write more nim code, but I will fix bugs in this repo.

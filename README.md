# enumerator

This is the repository for Zach's enumerator of grid graph partitions.
For details about the algorithm and an implementation, see the Jupyter notebook.

The enumerations folder contains .zips of the enumerations of the valid partitions.  Each zip contains a single text file.
The data format is as follows.  Each partition is on its own line.  Reading off the grid left-to-right, top-to-bottom,
a partition appears as a comma-delimited list where each value corresponds to the chunk to which that cell belongs.  For
example, the partition

`1 1 2\n
1 2 2\n
3 3 3
`
is represented as `1,1,2,1,2,2,3,3,3`.

The file naming convention is `[<m>,<n>]_[<p_1>,<p_2>,...,<p_l>]_k_<cont>.zip` where `m` and `n` are the 
dimensions of the grid, the `p_i` are the allowed sizes of the chunks, `k` is the number of pieces, and 
`cont` is either `rc` for rook contiguity or `qc` for queen contiguity.  The .zip contains a .txt file of 
the same name.

This is Julia code.  If you already have Julia and Jupyter installed, you can
set up IJulia by calling `Pkg.add("IJulia")` in the Julia REPL.  If you don't
have either of these set up, you can get Julia from the creators at julialang.org
and Jupyter from jupyter.org.

Coming soon: a command line version of this tool

# enumerator

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3467675.svg)](https://doi.org/10.5281/zenodo.3467675)


This code enumerates the polyomino tilings of a grid graph.
For details about the algorithm and implementation, see the [Julia implementation notebook](/gridenum_nb_julia.ipynb).


A partition of an `m` by `n` grid into `k` pieces of sizes in a list `[<p_1>,<p_2>,...,<p_l>]` is 
a collection of `k` disjoint, connected subgraphs of the `m` by `n` grid which cover the grid itself, and 
the number of vertices in each subgraph is in the list `[<p_1>,<p_2>,...,<p_l>]`

For example, the following is a partition of the 3 by 3 grid graph into 3 pieces of size 3

```
1 1 2  
1 2 2  
3 3 3
```

This code counts all such partitions and (if desired) outputs them into a text file.  The data format is 
a left-to-right, top-to-bottom linearization of the partition.  For example, the above partition would be 
serialized as

 `1,1,2,1,2,2,3,3,3`.


The code allows the use of rook or queen contiguity.  Rook contiguity means that the subgraphs in the partition 
must be composed of cells which meet only along the edges of the squares in the grid, while 
queen contiguity also permits cells which meet at corners.


Unfortunately, even for small input values, the number of valid tilings can be extremely large, numbering in the billions or trillions.  If you'd like the output for some smaller grids, please contact the author.

This is Julia code.  If you already have Julia and Jupyter installed, you can
set up IJulia by calling `using Pkg` and `Pkg.add("IJulia")` in the Julia REPL.  If you don't
have either of these set up, you can get Julia from the creators at julialang.org
and Jupyter from jupyter.org.

Cite this code as 
```
@misc{schutzman2019enumerator, 
        title={zschutzman/enumerator: v0.1.5}, 
        DOI={10.5281/zenodo.3467675}, 
        abstractNote={Code for enumerating polyomino tilings of grid graphs.}, 
        publisher={Zenodo}, 
        author={Zachary Schutzman}, 
        year=2019, 
        month=10,
        url={https://github.com/zschutzman/enumerator},
}
```

This code is available under an [MIT License](https://opensource.org/licenses/MIT).  


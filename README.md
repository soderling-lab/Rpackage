# Rpackage

Creating an R package is simple with `devtools` and `git`.

There are three essential `devtools` commands that you will need to create an R package.
* `devtools::create("packageName")` - use `create` to create a empty R package.
* `devtools::document()` - use `document` to generate documentation for R
    functions and data (see below).
* `devtools::install_github("user/packageName")` - use `install_github` to install
    a github user's package.

Finally, you will probably also need to use `devtools::load_all()` to load your
package as it is locally. You will then have access to its functions, data, and
documentation. 


## Creating a new package

Start by creating a new directory for your package, in the terminal type:
```bash

mkdir Rpackage

```

Now, launch the R interpreter by typing `R` into the terminal, and use
`devtools` to populate this directory with an empty new package.

```R
devtools::create("Rpackage")

```

You will find a couple of new files in your new directory:
```bash
cd Rpackage
ls -1

# DESCRIPTION
# NAMESPACE
# R

```

You can edit the `DESCRIPTION` file with information about your package. You should also create a README and add a license.
See github for more about adding a license: https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/licensing-a-repository


## Creating and documenting functions

Put R functions in the `R/` directory. I typically put each function in a
seperate R file.  Document your function with `Roxygen2` markdown syntax. At a
minimum, your function's header should start with the name of your function and
include an `export` statement. See [Karl
Broman's](https://kbroman.org/pkg_primer/pages/docs.html) tutorial for more.
Include `import` statements to insure that any required dependencies are
documented in the `NAMESPACE` file.  After creating a function, simply use
`document` to generate its documentation--this will be put in the `man/`
directory and saved as an `.Rd` file. See [hello.R](./R/hello.R) as an
example.


## Sharing your package

Sync your changes with github using git.
Start by creating a new repository on github by navigating to
https://github.com/new. Add a `Repository name` and `Description`. Don't
initialize the repository with any files, just click `Create repository`.
Now, return to the terminal and complete the local set-up:

```bash
git init # create a local git repository
git add . # add all files in current working directory
git commit -m "first commit" # comment on your progress
git branch -M main # create a branch
git remote add origin https://github.com/soderling-lab/Rpackage.git # track remote url
git push -u origin main # push changes to git
```


## Including data

A powerful feature of R is its ability to share data. Use the `save` command to
save R objects. Use the `data` command to load data associated with an R package.
Use `help` to view an R data object's documentation.

```R
## saving an R object

hi <- "hello world!"
save(hi, file="hi.rda", version=2)


## loading an R object
#devtools::install_github("soderling-lab/Rpackage")

data("hi", package="Rpackage")


## getting help 

help("hi", package="Rpackage")

```

Save R objects with the `save` command. It's best practice to save the object
using the same filename (e.g. `hi` saved as `hi.rda`). You must explicitly
provide `file` and `version` arguments to `save`. Use `version=2` to avoid
warnings about the data version when installing the package. Put saved `rda`
files in the `data/` directory.  Document the data by generating a Roxygen2
formatted file in the `R/` directory.  Note that the `@name` field is required
an the data's documentation should end with `NULL`.  See [data.R](./R/data.R) as a minimal example. Finally, be sure to call
`devtools::document` to generate the documentation!

You can also include raw data in `inst/extdata`, these files are not loaded when
loading your package. Don't make your package too big by considering which
objects you save and include in `inst/extdata`.

After loading your package (`library(Rpackage)`) you can access its data
(`data(hi)`). You can also more explicitly load a piece of data from any package
with `data("hi", package="Rpackage")`. 

See https://r-pkgs.org/data.html#documenting-data for more about documenting
data.

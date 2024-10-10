# Pharo Type Info Tools

This repository contains experimental tools for type inference in Pharo. The main objective is to integrate and leverage existing type inference tools for various purposes.

## Features

- Select an instance or temporary variable and press `Ctrl`/`Cmd` + `Shift` + `T` to display unified type inference results from multiple tools.

## Compatibility

The code has been tested with Pharo 13. It may not be compatible with earlier versions.

## Installation

To install, use the following Metacello script:

```smalltalk
Metacello new
    baseline: 'TypeInfoTools';
    repository: 'github://JanBliznicenko/TypeInfoTools';
    load.
```

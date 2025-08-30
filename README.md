# Pharo Type Info Tools

This repository contains experimental tools for type inference in Pharo. The main objective is to integrate and leverage existing type inference tools for various purposes.

## Features

- Select an instance, temporary variable, method or message send and press `Ctrl`/`Cmd` + `Shift` + `T` to display unified type inference results from multiple tools.
- Select an a message send and press `Ctrl`/`Cmd` + `Shift` + `M` to open implementors with most probable ones at the top
- Replaces code typing completion by slower but more precise version

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

TITNameStatisticsTyper/TITNameStatisticsTyperAdaptor need directory *name-type-statistics* to be copied to the directory of the image. 

## Data directories

It contains CSV files (semicolon delimited) with typical variable types / return types per name, beginning of name or ending of name, by words, cleaned from "a", "an", "each" and "other" and unified casing. It has 4 columns.

In case of methods, those columns are:

* Name: Selector of the method
* Type: Most common type
* Ratio: Amount of recorded senders of such method that got returned this most common type, divided by total amount of senders recorded
* Amount: Total amount of senders recorded

In case of variables, those columns are:

* Name: Name of the variable
* Type: Most common type
* Ratio: Amount of recorded receivers whose methods assigned this most common type, divided by total amount of recorder receivers whose methods assigned anything
* Amount: Amount of recorder receivers whose methods assigned anything

*real-time-outputs* contain raw or just partially processed data from the inference, in STON format

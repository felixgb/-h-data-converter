# h-data-converter

## Install

`stack setup && stack build` in project root dir

## Usage

convert fprogram to data representation

`stack exec -- h-data-converter-exe -fd <fwhile program as string surrouded by quotes>`

convert tree to list of numbers example

`stack exec -- h-data-converter-exe -nl "<nil.nil>"`

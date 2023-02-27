# Ruby puzzle solver for https://github.com/EvgeniyShelest/color_sort_js

## Recursive depth first traverse over tree of potential moves.


Generating flask set, shuffle and solve it using `color_sort_solver` shell script:

```
$ ./color_sort_solver 6 4
"flask amount: 6"
"flask capacity: 4"
 _  1  3  2  _  _  _  1
 _  6  6  3  5  _  _  6
 _  2  3  2  4  1  6  4
 4  2  4  3  5  5  1  5
"Press Enter to resolve or other key to exit."

{:count=>0}
{:level=>1}
{:released=>0}
{:do_move=>[[1, 3], [5, 2]]}
 _  _  3  2  _  _  _  1
 _  6  6  3  5  1  _  6
 _  2  3  2  4  1  6  4
 4  2  4  3  5  5  1  5

 ...

{:count=>26}
{:level=>26}
{:released=>1}
{:do_move=>[[7, 0], [4, 3]]}
 1  2  4  3  5  6  _  _
 1  2  4  3  5  6  _  _
 1  2  4  3  5  6  _  _
 1  2  4  3  5  6  _  _
"Moves amount: 26"
```


Generating flask set, shuffle and solve it using `irb`:

```
$ irb
> load 'flask_set.rb'
=> true
> t = FlaskSet.new
 1  2  3  4  _  _
 1  2  3  4  _  _
 1  2  3  4  _  _
 1  2  3  4  _  _
=> nil
> t.shuffle
...
"------------------"
 _  3  _  _  1  _
 _  4  _  _  1  2
 _  2  3  4  4  2
 2  3  3  4  1  1
"------------------"
> t.resolve
...
{:count=>11}
{:level=>12}
{:released=>0}
{:do_move=>[[5, 0], [1, 3]]}
 2  1  3  4  _  _
 2  1  3  4  _  _
 2  1  3  4  _  _
 2  1  3  4  _  _
"Moves amount: 12"
=> "SOLVED!"
```
OR initialize custom flask set in `irb`:

```
$ irb
> load 'flask_set.rb'
=> true
FlaskSet.new([[1, 1, 4, 0], [2, 2, 1, 4], [3, 3, 0, 0], [4, 0, 0, 0], [2, 4, 2, 3], [3, 1, 0, 0]])
```

-----
Default generator is:
```
> FlaskSet.generator
=> #<FlaskSetGenerator:0x00007feb741eb358 @flask_amount=4, @flask_capacity=4>
```
to replace it with configured new one:
```
> FlaskSet.generator = FlaskSetGenerator.new(10, 7)
=> #<FlaskSetGenerator:0x00007feb743a0ea0 @flask_amount=10, @flask_capacity=7>
```

# Simple-Network-on-Chip-router

A 3x3 network on chip. Nine nodes, one router each, single word packets, XY dimension order routing, one clock cycle per hop. The top level wires the rows and columns into rings, so the topology is a bidirectional torus.

## Data word

The word is 37 bits. That is payload 0 to 31, X 32 to 33, Y 34 to 35, valid 36:

| Bits | Field | Description |
| --- | --- | --- |
| `[36]` | `valid` | 1 means the word carries a packet, 0 means the link is idle |
| `[35:34]` | `y` | destination row |
| `[33:32]` | `x` | destination column |
| `[31:0]` | `data` | payload, never inspected by the router |

The code `2'b00` is reserved in both coordinate fields and means "no address".
A word is a packet only when the valid bit is high **and** neither coordinate holds `00`. It follows that no router may be given a location of the form `00xx` or `xx00`, which is achievable in a 3x3 network.

## Address map

Nodes are labelled A to I. The router address is supplied on the `location` input as `{y, x}`.

|  | x = 01 | x = 10 | x = 11 |
| --- | --- | --- | --- |
| **y = 01** | A | B | C |
| **y = 10** | D | E | F |
| **y = 11** | G | H | I |
This gives the location for each node as follows:

| Node | y | x | `location[3:0]` |
| --- | --- | --- | --- |
| A | 01 | 01 | 0101 |
| B | 01 | 10 | 0110 |
| C | 01 | 11 | 0111 |
| D | 10 | 01 | 1001 |
| E | 10 | 10 | 1010 |
| F | 10 | 11 | 1011 |
| G | 11 | 01 | 1101 |
| H | 11 | 10 | 1110 |
| I | 11 | 11 | 1111 |

## Topology

`noc_top` instantiates nine routers and closes every row and every column into a ring, so there are no edges and no tied off ports.

Row rings:
A-B-C-A
D-E-F-D
G-H-I-G

Column rings:
A-D-G-A
B-E-H-B
C-F-I-C

Link wires are named `[src]_[dst]_[direction]`, so `a_b_e` is the word travelling east out of A into B, and `c_a_e` is the wrap that closes the top row. Every neighbour pair has one wire in each direction.

## Module interface

### `router`

| Port | Dir | Width | Description |
| --- | --- | --- | --- |
| `clk` | in | 1 | clock, everything happens on the rising edge |
| `rst_n` | in | 1 | reset, active low, sampled synchronously |
| `location` | in | 4 | this router's address, `{y, x}`, held constant |
| `east_in`, `west_in`, `north_in`, `south_in`, `local_in` | in | 37 each | incoming words |
| `east_out`, `west_out`, `north_out`, `south_out`, `local_out` | out | 37 each | outgoing words |

### `noc_top`

| Port | Dir | Width | Description |
| --- | --- | --- | --- |
| `clk`, `rst_n` | in | 1 each | as above |
| `local_in_a` to `local_in_i` | in | 37 each | injection, one per node |
| `local_out_a` to `local_out_i` | out | 37 each | ejection, one per node |

### Internal registers

`east_reg`, `west_reg`, `north_reg`, `south_reg`, `local_reg`, 37 bits each. One output register per port, wired straight to the matching output.

## Routing

The x coordinate is corrected first, and the y coordinate only once the column matches. For an incoming word with destination `(yd, xd)` at a router at `(ym, xm)`:

| Condition | Output |
| --- | --- |
| `xd > xm` | east |
| `xd < xm` | west |
| `xd == xm` and `yd > ym` | south |
| `xd == xm` and `yd < ym` | north |
| `xd == xm` and `yd == ym` | local |

The y dimension is only evaluated once `xd == xm`, and a packet never turns from the y dimension back into the x dimension. It also means a packet arriving on the north or south port is already in its destination column, so it can only leave north, south or local.

### Worked example

A packet injected at A (y=01, x=01) for F (y=10, x=11):

1. At A, `xd = 11 > xm = 01`, so it leaves on `east_out`.
2. At B (y=01, x=10), `xd = 11 > xm = 10`, so it leaves on `east_out`.
3. At C (y=01, x=11), the column matches and `yd = 10 > ym = 01`, so it leaves on `south_out`.
4. At F the address matches exactly, so it leaves on `local_out`.

Three hops, four register stages, so the packet appears at F's local port four clock cycles after A accepted it. Latency is `hops + 1` cycles.

### The torus is unused

The comparisons above never send a packet across a wrap. A packet at x=01 addressed to x=11 walks east through x=10 rather than taking the single westward wrap hop. The logic needs to be implemented to shorten the path for the packets. The extra wires and the unused ports are removed during synthesis.

## Arbitration

Each output register has its own fixed priority chain of candidate inputs. The input facing an output is never a candidate for it, so a packet will never return through the path it came.

| Output | Candidate inputs, highest priority first |
| --- | --- |
| east | west, north, south, local |
| west | east, north, south, local |
| north | east, west, south, local |
| south | east, west, north, local |
| local | east, west, north, south |

The priority of inputs is east, then west, then north, then south, then local, skipping whichever input faces the output being decided. The local input is last on every list, so no new packets will take priority over packets already in transit. Any packet not sent is dropped. Any packet from a lower priority input will be dropped if a higher priority packet wants the same output. A packet from a node to itself is assumed handled by the network interface and never enters the network.

## Reset and timing

Reset is synchronous and active low. While `rst_n` is low, all five output registers are set to zero. Every output register is also assigned zero as a default at the top of the cycle and is only overwritten if a packet is selected for it. An output therefore never holds a stale packet for more than one cycle, and no packet is ever sent twice.

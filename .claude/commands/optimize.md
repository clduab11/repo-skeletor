---
description: Optimize the selected code for performance
---

Optimize the selected code. Before writing any change, identify the bottleneck:

- Algorithmic (wrong data structure, quadratic loop, repeated work)
- I/O-bound (sequential awaits that could be `Promise.all`, unbatched DB calls, N+1)
- Memory-bound (accumulating large structures, no streaming)
- CPU-bound (JSON.parse on hot path, unnecessary deep clones)

Output:

1. The optimized code.
2. A before/after complexity estimate (Big-O or rough timing).
3. Any trade-off introduced — readability, memory, or correctness under concurrency.

If the only honest answer is "not worth optimizing", say so.

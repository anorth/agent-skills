# Concurrency

Review guidance for diffs that touch shared mutable state, coroutines/threads, timers and callbacks, or state-mutation transactions.

## Shared mutable state
- Every read *and* write of shared mutable state needs synchronization — audit for the read side, which is the usual omission.
- Compound updates (read-modify-write, multi-field invariants) require a mutex; an atomic container or concurrent collection only makes each individual operation safe.
- Collapse check-then-act on mutable collections into one lookup that both tests for a match and returns the value.
- Return defensive copies of mutable values from synchronized containers, so callers cannot mutate protected state after the lock is dropped.
- Pass per-item inputs explicitly as parameters instead of stashing them in shared mutable fields between calls.

## Timers, callbacks, and lifecycle
- Define the safe behavior for unexpected, duplicate, stale, or late-arriving callbacks; leaving it undefined is a defect even if the current caller can't trigger it.
- Don't overwrite a pending timeout/deadline with a later one unless the earlier one has already fired or is provably unnecessary.
- Update retry/rebroadcast bookkeeping *before* scheduling the next timeout, especially when several timer-driven paths can share a deadline.
- Specify the ordering or synchronization between synchronous operations and timer/alarm callbacks that touch the same state.
- Order deferred confirmation against expiration so an accepted operation cannot expire before it can possibly be confirmed.
- Base latches, signals, and their documentation on operation *completion*, not on dispatch of the operation.
- Don't wrap an operation that already enforces and reports its own timeout in another timeout layer.

## Asynchrony as an API choice
- Don't reach for channels or callbacks in internal APIs when synchronous iteration or a direct return gives the required semantics.
- Let callers opt into synchronous handling when they may need the consumer to finish before proceeding.
- Use the same execution model (sync vs. async) for equivalent lifecycle entry points; asymmetry there is a bug source.
- Centralize event-loop control flow so queue draining and blocking are explicit in one place rather than duplicated across handlers.

## Limits, backpressure, and resources
- Default concurrency limits should be conservative; larger values need measured resource and latency justification.
- Size work queues to expected producer/consumer rates so workers don't repeatedly go idle waiting for the next item.
- Release each concurrency permit/slot at a single unconditional point unless a later path genuinely must keep holding it.
- Opportunistic or racing fetch strategies need a reliable fallback for transient failure.

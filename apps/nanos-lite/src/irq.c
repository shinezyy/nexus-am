#include "common.h"

_RegSet* schedule(_RegSet *);
_RegSet* do_syscall(_RegSet *);

static _RegSet* do_event(_Event e, _RegSet* r) {
  _RegSet *ret = NULL;

  switch (e.event) {
    case _EVENT_IRQ_TIME: ret = schedule(r); break;
    case _EVENT_TRAP: ret = schedule(r); break;
    case _EVENT_SYSCALL: ret = do_syscall(r); break;
    default: panic("Unhandled event ID = %d", e.event);
  }

  return ret;
}

void init_irq(void) {
  _asye_init(do_event);
}

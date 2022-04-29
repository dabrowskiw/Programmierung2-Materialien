---
marp: true
theme: HTW
paginate: true
footer: Dr. Katrin Lang / Prof. Dr.-Ing. P. W. Dabrowski - Programmierung 2 - HTW Berlin
---


# Intrefaces

Beispiel aus der letzten Woche: `return "Weiß ich nicht :("` ist unschön 

```java
public class Uhr {
  public String tick() { return "Weiß ich nicht :("; }
}
public class Turmuhr extends Uhr {
  public String tick() { return "TICK! TOCK!"; }
}
public class Armbanduhr extends Uhr {
  public String tick() { return "Ticketacke."; }
}
Turmuhr bigBen = new Turmuhr();
boolean isTurmuhr = bigBen instanceof Turmuhr; // true
boolean isUhr = bigBen instanceof Uhr; // true
boolean isArmbanduhr = bigBen instanceof Armbanduhr; // false
```


---

# Abstrakte Klassen

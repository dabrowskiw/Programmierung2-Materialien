---
marp: true
theme: HTW
paginate: true
footer: Dr. Katrin Lang / Prof. Dr.-Ing. P. W. Dabrowski - Programmierung 2 - HTW Berlin
---

# Observer pattern

* Patterns: Gängige Muster zur Lösung typischer Anforderungen
* Observer pattern:
    * Dinge passieren mit etwas ("subject")
    * Andere Dinge wollen dann benachrichtig werden ("observer")
* Beispiele:
    * Angeschlossene Geräte sollen benachrichtigt werden, wenn der Luftdruck des Kompressors sich ändert
    * Berechnungslogik soll benachrichtigt werden, wenn ein Button angeklickt wurde

---

# Observer-Minimalbeispiel

```java
public interface ButtonObserver {
    public void onClick();
}
public class ClickObserver implements ButtonObserver {
    public void onClick() { System.out.println("Klick!"); }
} 
public class Button {
    private LinkedList<ButtonObserver> obs;
    public void addObserver(ButtonObserver o) {obs.add(ob); }
    public void buttonBlicked() {
        for(ButtonObserver o : obs) {
            o.onClick();
        }
    }
}
```

---

# Interne Klassen

* Häufiges Problem: Observer sind spezifisch für Ereignis -> nur lokal relevant, restliches Programm interessiert sich nicht dafür
* Aber: Observer-Objekte nätig für Observer-Verwaltung
* Lösung: Interne Klassen (ein wenig wie Methoden)

---

# Interne Klassen: Beispiel

```java
public class GUI {
    protected class ClickObserver implements ButtonObserver {
        public void onClick() { System.out.println("Klick!"); }
    } 
    public GUI() {
        Button button = new Button();
        button.addObserver(new ClickObserver());
    }
}
```

---

# Anonyme Klassen

* Schlankste Alternative: Anonyme Klasse. Kein Name, gar nicht wiederverwendbar, "lokaler Code als Objekt verpackt": 

```java
public class GUI {
    public GUI() {
        Button button = new Button();
        button.addObserver(new ButtonObserver() {
            public void onClick() { 
               System.out.println("Klick!");
            }
        });
    }
}
```

---

# Event Handling in Swing

* `JComponents` (subject) verwalten Liste von `EventListener` (observer)
* `EventListener` ist nur Interface
    * Werden konkret implementiert für konkrete Ereignistypen, z.B.:
        * `ActionListener`: Click auf Button etc.
        * `KeyListener`: Taste gedrückt/losgelassen
    * Methoden für konkrete Events, z.B. `KeyListener`: `keyPressed` etc.
* Konkrete `JComponents` haben spezialisierte Methoden für konkrete `EventListener`, z.B. `JButton.addActionListener()` - nicht für jede `JComponent` wären alle konkreten `EventListener` sinnvoll.

---

# Event Handling in Swing - Minimalbeispiel

```java
public class EventDemo extends JFrame {
    public EventDemo() {
        JButton helloButton = new JButton("Say hi!");
        helloButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent actionEvent) {
                System.out.println("Hallo!");
            }
        });
        add(helloButton);
    }
    public static void main(String[] args) {
        EventDemo demo = new EventDemo();
        demo.setVisible(true);
    }
}
```

---

# Standard-Komponenten: JDialog

* Für viele Standard-Aufgaben Komponenten vorhanden
* [JDialog](https://docs.oracle.com/javase/tutorial/uiswing/components/dialog.html): Modale Dialoge (Fehler, Abfrage, Texteingabe...) anzeigen

```java
public class DialogDemo extends JFrame {
	public DialogDemo() {
		JOptionPane.showMessageDialog(this, "Hi there!");
		int choice = JOptionPane.showOptionDialog(this, 
                        "What'green?", "Question", 0, 0, null, 
                        new Object[] {"Grass", "Water"}, "Grass");
	}
	public static void main(String[] args) {
		new DialogDemo().setVisible(true);
	}
}
```

---

# Standard-Komponenten: JFileChooser

* Andere Standard-Aufgabe: Datei auswählen -> [JFileChooser](https://docs.oracle.com/javase/tutorial/uiswing/components/filechooser.html)

```java
public class FileChooserDemo extends JFrame {
	public FileChooserDemo() {
		JFileChooser chooser = new JFileChooser();
		int res = chooser.showOpenDialog(this);
		if(res == JFileChooser.APPROVE_OPTION) {
			File chosen = chooser.getSelectedFile();
		}
	}
	public static void main(String[] args) {
		new FileChooserDemo().setVisible(true);
	}
}
```

---

# Standard-Komponenten: BufferedImage

* Häufige Aufgabe von GUIs: Bilder anzeigen/speichern
* `BufferedImage`: 2D-Array von Pixeln
* Lese- und Schreibmethoden in `ImageIO`, z.B. `ImageIO.read(File f)`
* Verändern:
    * Farbe über `Color`-Klasse
    * Direkter Pixelzugriff über `BufferedImage.setRGB()`, Farbe in richtiger Codierung (x byte ARGB, GRAY...) von `Color.getRGB()` 
    * Zeichenoperationen wie Linien über `Graphics` aus `BufferedImage.getGraphics()`
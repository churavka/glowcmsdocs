# Stream Elements

Systém `StreamElements` tvoří zobrazovací vrstvu (UI) celého CMS. Elementy jsou stavební kameny, které se starají o rendering HTML, správu doprovodných assetů (JS/CSS) a poskytují API pro interakci s ostatními částmi systému (jako jsou Streamy a Formy).

## Struktura systému

Elementy jsou rozděleny do tří hlavních kategorií podle svého účelu:

### 1. Base (Základní prvky)
Nacházejí se v `glow/Modules/StreamElements/Libraries/Base`.
- **Element:** Základní třída pro všechny prvky. Obsahuje logiku pro správu ID, tříd, data-atributů a základní rendering (`view()`).
- **ElementGroup:** Umožňuje sdružovat více elementů do jednoho celku (např. tlačítko s ikonou).
- **ElementBuilder:** Nízkoúrovňový nástroj pro programové skládání HTML struktur.

### 2. Form (Formulářové prvky)
Nacházejí se v `glow/Modules/StreamElements/Libraries/Form`.
- Dědí z `FormElement`.
- **Funkcionalita:** Zpracovávají Label, instrukce, chybové zprávy a stavy (disabled, readonly, required).
- **Příklady:** `Input`, `Select2`, `Checkbox`, `DatePicker`.
- Automaticky se starají o to, aby ID prvku odpovídalo názvu pole ve formuláři (slug).

### 3. List (Prvky pro výpisy)
Nacházejí se v `glow/Modules/StreamElements/Libraries/List`.
- Slouží k vykreslování datových přehledů.
- **AppTable:** Komplexní element, který v součinnosti s `StreamList` generuje responvzi tabulky včetně záhlaví, řádků a paginace.
- Umožňuje definovat custom šablony pro řádky (`setViewRow`).

---

## Správa Assetů (JS & CSS)

Jednou z klíčových vlastností Elementů je schopnost "přibalit" si vlastní závislosti. Většina komplexnějších prvků (jako `Select2` nebo `DatePicker`) si v konstruktoru volá metodu `loadAsset()`.

```php
private function loadAsset() : void
{
    // Registrace pluginu z globální složky plugins
    assets()->plugin('select2/js/select2.js', 'plugins', true);
    assets()->plugin('select2/css/select2.css', 'plugins', true);
    
    // Načtení specifické lokalizace (např. čeština)
    assets()->plugin('select2/js/i18n/cs.js', 'plugins', true);
}
```

Elementy také často generují asynchronní (inline) JavaScript pro inicializaci UI knihoven (např. Select2, jQuery pluginy) pomocí `assets()->addJsInline($js)`.

---

## Budoucí vývoj a UI integrace

Systém Elements se neustále vyvíjí směrem k větší flexibilitě a propojení s vizuální stránkou (Themes):

### 1. Podřízení složky Elements aktuálnímu tématu (Themes)
Plánovaným vylepšením je mechanizmus **přetěžování (overloading)**. To umožní, aby si aktuálně aktivní téma (Theme) mohlo definovat vlastní implementaci nebo vizuální šablonu (View) pro konkrétní element. 
- *Příklad:* Pokud máte téma "Modern", systém se nejdříve podívá do `themes/modern/Elements/Form/Select2.php` (nebo .phtml), než použije výchozí implementaci v modulu.

### 2. Hlubší integrace s UI
Elementy se budou více propojovat s třídou `Glow\UI\UICard` a dalšími layoutovými prvky, aby bylo možné z controleru definovat komplexní dashboardy a admin rozhraní pomocí čistého PHP kódu bez nutnosti psát ručně HTML šablony.

---

> [!TIP]
> Při tvorbě nového elementu vždy dělejte z příslušné základní třídy (`FormElement` pro formuláře) a využívejte helper `assets()` pro správu závislostí, aby se stejné skripty nenačítaly na jedné stránce vícekrát.
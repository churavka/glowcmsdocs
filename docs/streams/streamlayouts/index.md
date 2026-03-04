# Stream Layouts

`StreamLayouts` definují celkovou strukturu stránek a kontejnerizaci obsahu v administraci. Systém umožňuje skládat složitá rozhraní pomocí PHP kódu, který se stará o grid systém (řádky a sloupce) a obalové prvky (karty, taby, modály).

## Základní koncept (StreamContent)

Všechny layoutové prvky dědí od základní třídy `Glow\Streams\Libraries\StreamContent`. Tato třída poskytuje jednotné rozhraní pro vkládání polí, elementů a jiného obsahu.

### Klíčové metody pro sestavování layoutu

Layout se dělí na dvě hlavní oblasti: **Filter** (horní část pro vyhledávání) a **Stage** (hlavní obsahová část).

- **stageField(streamSlug, fieldSlug):** Vloží pole ze streamu do hlavní části.
- **stageElement(element):** Vloží UI element do hlavní části.
- **stageContent(content):** Vloží jiný `StreamContent` prvek (např. kartu do tabu).
- **stageLineEnd():** Ukončí aktuální řádek a začne nový.
- **filterField / filterElement / filterContent:** Analogické metody pro hierarchicky vyšší filtrační oblast.

## Hlavní layoutové kontejnery

### 1. StreamContentCard (Karta)
Základní stavební blok administrace. Odpovídá Bootstrapové kartě (`.card`).

```php
$card = new StreamContentCard('moje_id');
$card->header()->title('Titulek karty');
$card->stageField('catalog_products', 'name');
$card->stageLineEnd();
```

### 2. StreamContentTabs (Záložky)
Umožňuje rozdělit obsah do více záložek. Každá záložka (`newTab`) inicializuje vlastní unikátní "Stage" oblast.

```php
$tabs = new StreamContentTabs('tabs_id');
$tabs->newTab('Hlavní', 'url/pro/ajax_refresh');
$tabs->stageField('stream', 'field1');

$tabs->newTab('Detaily');
$tabs->stageField('stream', 'field2');
```

---

## Grid Systém (Lines & Columns)

Uvnitř každého kontejneru se obsah automaticky řadí do řádků. Každé volání `stageField` nebo `stageElement` vytvoří v aktuálním řádku nový sloupec.

### Práce se sloupci
Můžete ovlivnit šířku sloupce pomocí metody `colWidth(int)` (podle 12-sloupcového Bootstrap gridu):

```php
$card->stageField($slug, 'code')->colWidth(2);
$card->stageField($slug, 'name'); // Zabere zbytek řádku nebo defaultní šířku
$card->stageLineEnd(); // Vynutí nový řádek
```

---

## Propojení s formuláři

Layouty jsou úzce spjaty se správou formulářů (`FormManager`). Můžete určit, zda má formulář obalovat celou kartu, nebo jen její části (Filter/Stage).

- **$card->form($formManager):** Obalí celou kartu tagem `<form>`.
- **$card->stageForm($formManager):** Obalí pouze hlavní obsahovou část.

---

> [!NOTE]
> Celý systém je navržen tak, aby minimalizoval nutnost psát HTML v kontrolerech. O správné vnořování tagů a generování mřížky se starají knihovny `LayoutBuilder` a `StreamContentLayoutLines`.

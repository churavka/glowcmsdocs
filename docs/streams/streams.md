# STREAMS - Jak to funguje

`Streams` si můžeme představit jako virtuální tabulky v databázi, případně jako modely. V databázi (v tabulce streamů) definujeme logický název a vlastnosti tohoto streamu.

Každý stream (tabulka) obsahuje `StreamFields`. Ty přiřazujeme k jednotlivým streamům v administraci. `StreamField` je něco jako konkrétní definice sloupce v databázové tabulce (např. sloupec `title` nebo `price`). 

Každému sloupci (`StreamField`) následně přiřazujeme specifický typ pole – **FieldType** (např. *Text*, *Decimal*, *Relationship*, *CheckboxOptions*). 

### Jak to do sebe zapadá (Architektura)

1. **Stream (Model/Tabulka):** Definuje "Co" ukládáme (např. *Produkty*). 
2. **StreamField (Sloupec):** Definuje konkrétní atributy a potřebné parametry pro daný stream (zda je pole povinné, jaké má omezení, jaké jsou vazby - např. *Cena produktu*).
3. **FieldType (Logika typu pole):** Definuje, jak se daný datový typ chová. Nese v sobě pravidla pro daný typ obsahu. **Typ pole má vždy interně přidělený defaultní `StreamElement`**, který se stará o jeho fyzické zobrazení v HTML (pokud toto chování nepřetížíme v Controlleru pomocí callbacku). 
   - *Důležitá vlastnost:* Typ pole (FieldType) může obsahovat metody chovající se jako **Hooky**. Může měnit a formátovat data *před jejich zobrazením* (např. ve formuláři či listu) a také *před jejich uložením* do databáze (např. hashování hesel, přepočty měn, serializace do JSON).
4. **StreamElements (Zobrazovací vrstva):** Element je nadstavba nad FieldType. U formulářových polí generuje přímo HTML tagy (`<input>`, `<select>`). Obecně se ale stará i o rendering mnohem komplexnějších UI komponent celého CMS (jako jsou *AppList*, *AppTable*, *Form*, *StreamContentTabs*, *StreamContentCard* a další).
5. **StreamsLayouts:** Architektonická vrstva, která v sobě sdružuje jednotlivé elementy, pole, nebo i čisté HTML, a skládá z nich finální strukturu (layout) na výsledné stránce.
6. **StreamsValues:** Speciální vrstva sloužící pro ukládání hodnot z některých dynamických streamů (systém EAV).

---

Příklad Controlleru:

```php
$StreamsManager = new \Glow\StreamFields\Libraries\StreamsManager();
$StreamsManager->getStream('data_streams');

$tabs = new \Glow\Streams\Libraries\StreamContentTabs('streams');
$tabs->jsFilterList('StreamsCard')->load();
$tabs->newTab('Streams', 'admin/streams?aaa=bbb', true);

$card = new \Glow\Streams\Libraries\StreamContentCard('StreamsCard');
$card->setHeader( \Glow\UI\UICard::make()->header('Přehled streamů')->addSearch('admin/streams') );
$card->form(new \Glow\StreamFields\Libraries\FormManager(new \Glow\StreamElements\Libraries\Form\Form(), $StreamsManager));
$card->stageContent($tabs);

return admin()->stringToSection($card->view())->render();
```

# Stream Fields (FieldTypes)

`StreamFields` představují logickou vrstvu nad databázovými sloupci. Každé pole v rámci streamu má přiřazený svůj **FieldType**, který definuje, jak se s daty pracuje, jak se validují a jak se zobrazují.

## Obecná architektura

Každý `FieldType` je PHP třída rozšiřující základní třídu `Glow\StreamFields\Libraries\Type`. Tato třída definuje životní cyklus pole v rámci CMS.

Klíčové vlastnosti a metody:
- **Defaultní Element:** Každý typ má přiřazený UI prvek (např. Input, Select), který se stará o rendering.
- **Hooky (Zpracování dat):** Umožňuje modifikovat data v různých fázích (před uložením, před zobrazením).
- **Metadata:** Každý FieldType může mít v DB nadefinované vlastní metadata (např. počet desetinných míst, cílová tabulka pro relaci).

---

## Tvorba vlastního FieldType

Vlastní typy polí se nacházejí v adresáři `glow/Modules/StreamFields/FieldTypes/`. Každý typ má svou vlastní složku obsahující hlavní třídu.

### Struktura třídy

```php
namespace Glow\StreamFields\FieldTypes\CustomType;

use Glow\StreamFields\Libraries\Type;
use Glow\StreamElements\Libraries\Form\Input; // Příklad elementu

class CustomType extends Type
{
    protected $typeSlug = 'customtype'; // Unikátní identifikátor
    protected $typeName = 'Vlastní Typ';
    protected $dbType   = 'varchar';     // Typ v DB (varchar, text, int, float...)

    /**
     * Inicializace UI elementu
     */
    public function element() : void
    {
        // Vytvoření elementu (Label se přidá automaticky přes formField)
        $this->element = new Input($this->field->getName(), $this->getFormSlug());
        $this->element->formField(); 
    }

    /**
     * Hook před zobrazením ve formuláři/listu
     */
    public function preOutput()
    {
        $value = $this->getField()->getValue();
        // Logika úpravy...
        $this->getField()->setValue($value, false);
    }

    /**
     * Hook před uložením do databáze
     */
    public function preSave()
    {
        $value = $this->getField()->getValue();
        // Logika pročištění/validace...
        $this->getField()->setValue($value, false);
    }

    public function view() : string
    {
        return $this->element->view();
    }
}
```

---

## Detailní příklady

### 1. Typ Decimal

Typ `Decimal` ukazuje, jak pracovat s hooky pro formátování čísel (výměna čárky za tečku, zaokrouhlování).

- **Element:** Používá `Input` s typem `number`.
- **preSave():** Převede vstup na float, nahradí čárku tečkou a zaokrouhlí podle parametru `decimalPlaces`.
- **preOutput():** Formátuje hodnotu zpět pro lidsky čitelný výstup.

```php
// Ukázka logiky preSave v Decimal.php
public function preSave()
{
    $value = str_replace(',', '.', $this->getField()->getValue());
    $value = (float) round(
        filter_var($value, FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION), 
        $this->getFieldData('decimalPlaces')
    );
    $this->getField()->setValue($value, false);
}
```

### 2. Typ Relationship

Typ `Relationship` ukazuje, jak CMS automaticky řeší relace 1:N pomocí konfigurace.

- **Element:** Používá `Select2` pro vyhledávání.
- **Metoda fillElement():** Zde se odehrává automatické plnění daty.
- **RelationTableBuilder:** Sestavuje Query Builder nad tabulkou definovanou v parametrech pole (`relationTable`).

```php
// Ukázka plnění daty v Relationship.php
public function fillElement()
{
    // getRelationTableBuilder automaticky vytvoří dotaz podle nastavení v DB
    $data = $this->getRelationTableBuilder()->get()->getResult();

    foreach($data as $row) {
        $this->element->addOption(
            $row->titleField, 
            $row->id, 
            $this->field->getValue() == $row->id
        );
    }
}
```

Díky této architektuře stačí v databázi u pole nastavit např. `decimalPlaces` nebo `relationTable` a FieldType se postará o zbytek logiky bez nutnosti psát speciální kód v každém Controlleru.

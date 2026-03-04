# Architektura a konvence kódování (Glow CMS)

Glow CMS je postaven na revolučním přístupu **Streams (deklarativní UI a datový model)**. Naším cílem je psát co nejméně "tradičního" CRUD kódu a maximálně využívat abstrakci. Pro složitější byznys logiku pak aplikujeme striktní objektové principy, štíhlé třídy a ověřené návrhové vzory.

## Základní principy

1.  **Rozděl a panuj (Štíhlé třídy):** 
    Třída by měla mít pouze jeden důvod ke změně (Single Responsibility). **Vyhýbáme se obrovským "God Classes"**. Pokud třída dělá více věcí najednou, rozdělte ji do menších, specializovaných tříd.
2.  **Deklarativní přístup (Streams):** 
    Pro standardní výpisy, tvorbu a editaci záznamů **nepíšeme vlastní HTML ani složité SQL dotazy**. Používáme systém `StreamList`, `FormManager` a `StreamLayouts`. 
3.  **Návrhové vzory (Design Patterns):** 
    Složitější logiku řešíme pomocí standardních návrhových vzorů:
    *   **Adapter:** Pro integraci aplikací třetích stran (např. různé platební brány, ERP systémy), které sjednocujeme pod společný strom interfaces.
    *   **Strategy:** Zapouzdření rodiny algoritmů (např. výpočet ceny dopravy, aplikace slev). Rozdělíme logiku do malých tříd a v době běhu volíme správnou strategii.
    *   **Factory:** Pro izolaci složité logiky vytváření objektů, zejména pokud vytvoření entity vyžaduje napojení mnoha závislostí.
    *   **Observer/Event Dispatcher:** Uvolnění vazeb mezi moduly. Například vytvoření uživatele spustí event, který asynchronně odesílá uvítací e-mail v úplně jiné, izolované třídě.
4.  **Dependency Injection:** 
    Závislosti předáváme přes konstruktor. Minimalizujeme `new` uvnitř tříd (s výjimkou entit nebo drobných value objektů).

---

## Názvové konvence (Naming Conventions) a Vrstvy

Glow CMS využívá modulární strukturu. V rámci každého modulu dodržujeme následující členění:

### 1. Controllers (`/Controllers`)
**Role:** V Glow CMS má kontroler jedinou práci: **sestavit UI pomocí Streamů** nebo zpracovat **velmi jednoduchý HTTP vstup/výstup**. Nesmí obsahovat složitou logiku.
*   **Název:** `Admin[Název]`, `[Název]Controller` (např. `AdminProducts`, `ApiOrders`)
*   **Pravidlo Glow:** Standardní CRUD akce (`index`, `add`, `edit`) se neskládají z klasických formulářů a views. Využívá se `FormManager` a obaluje se do `StreamContentCard` nebo `StreamContentTabs`. Pokud formulář vyžaduje nestandardní zpracování polí, použije se **Callback** namapovaný na dané pole, nebo vlastní **FieldType**.

### 2. Models (`/Models`)
**Role:** Úzká slupka nad databází (Active Record v CI4). 
*   **Název:** `[NázevEntity]Model` (např. `ProductModel`)
*   **Pravidlo Glow:** Sem patří definice tabulky a relací (metoda `relationDefinition()`). Žádná byznys logika sem nepatří. Zabraňuje se vzniku "tučných" modelů.

### 3. Services (\` /Services \` a specifické jmenné prostory pro návrhové vzory)
**Role:** Zde se nachází srdce aplikace. Složité operace rozdělujeme raději do deseti malých Service/Strategy tříd než do jedné velké.
*   **Název:** `[NázevProcesu]Service`, nebo s využitím patternu např. `[Dodavatel]PriceStrategy`, `[System]ExportAdapter`.

### 4. FieldTypes a Components (`/FieldTypes`, `/Components`)
**Role:** Specifické rozšíření UI a logiky jednoho konkrétního sloupce/vlastnosti.
*   **Název:** Krátký vystihující název, např. `Relationship`, `Decimal`, `ImageUpload`.
*   **Pravidlo Glow:** Pokud opakovaně formátujete data před zobrazením nebo uložením, napište si vlastní `FieldType` s metodami `onLoad()` a `onSave()`. Udržuje to Controllers a Services čisté. Pokud se opakuje specifické UI (např. modální okno pro výběr pobočky), vyčleníme ji jako samostatnou **Component** (třídu dědící z `StreamContent`).
---

## Shrnutí pro vývojáře (a AI systémy)

Kdykoliv v Glow CMS tvoříš novou funkcionalitu:
1. Zeptej se, zda to nejde **vyřešit jen konfigurací ve Streams** a přidáním sloupce.
2. Pokud potřebuješ vlastní proces, napiš **štiplavou malou Service třídu**, ideálně navrženou pomocí určitého patternu (Strategy, Adapter, ...).
3. **Drž kontrolery co nejmenší.** 
4. Neřeš HTML ručně, pokud to zvládne `StreamContentCard` či `ElementBuilder`.
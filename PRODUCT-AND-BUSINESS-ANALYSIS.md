# Product management & business analysis skills

## Русский

Четыре самостоятельных навыка версии 1.0.0. Сохранена схема репозитория: русская версия без суффикса, английская — с `-en`.

| Роль | Русская версия | English version |
| --- | --- | --- |
| Продакт-менеджер | [product-manager](product-manager/SKILL.md) | [product-manager-en](product-manager-en/SKILL.md) |
| Бизнес-аналитик | [business-analyst](business-analyst/SKILL.md) | [business-analyst-en](business-analyst-en/SKILL.md) |

В каждой папке: `SKILL.md` с инструкциями и триггерами применения, `references/playbook.md` со словарём, шаблонами и синтетическим примером, `agents/openai.yaml` с метаданными интерфейса по принятому в репозитории образцу. Скрипты, доступ к сети и конкретный трекер не являются обязательными зависимостями. Работа с актуальными внешними данными требует доступного источника; отсутствие доступа нужно обозначать.

**Разделение ответственности.** PM определяет, чью проблему и ради какого результата решать, сравнивает инвестиции и проверяет ценность. BA уточняет, какие процессы, правила и проверяемые требования реализуют намерение. Архитектор выбирает техническое решение; QA проверяет поведение. Эти границы — правила данного пакета, не утверждение об одинаковой структуре всех компаний.

**Совместная работа.** PM передаёт problem statement, evidence, outcome, scope и ограничения. BA возвращает спецификацию, правила, исключения, traceability и открытые решения. Архитектор возвращает feasibility и trade-offs. PM или полномочный владелец разрешает влияние на продуктовый scope; BA обновляет baseline по подтверждённому решению. Упоминание роли не означает автоматический запуск агента или состоявшееся согласование.

**Использование.** Скопируй выбранную папку навыка целиком в каталог skills, поддерживаемый твоим агентом. Не копируй только `SKILL.md`: относительная ссылка на playbook должна сохраняться. Выбирай одну языковую версию роли для задачи; установка обеих не нужна для перевода ответа. Способ регистрации и вызова зависит от клиента. Для клиентов с синтаксисом `$skill-name`:

```text
$product-manager Оцени, стоит ли делать эту функцию. Выдай decision brief, альтернативы и план проверки самой рискованной гипотезы.
$business-analyst Преврати согласованный brief в требования: процесс, правила, исключения, AC и матрицу трассируемости.
```

Явный запрос пользователя на язык имеет приоритет над языком по умолчанию. Языковые версии имеют одинаковый набор обязанностей, ограничений и шаблонов; при изменении поведения обновляй обе версии и их version metadata. ID в примерах локальные и не создают задачи во внешнем трекере.

**Проверки.** Проверяй YAML frontmatter, соответствие `name` имени папки, доступность относительных ссылок, корректность `agents/openai.yaml`, согласованность RU/EN и отсутствие выдуманных фактов. Статическая проверка не доказывает качество работы модели: перед production-применением оцени ответы на реальные задачи с проверяемыми критериями.

## English

Four standalone skills, version 1.0.0. Russian uses the unsuffixed folder; English uses `-en`, following this repository’s convention. Each directory includes instructions in `SKILL.md`, vocabulary/templates/a synthetic example in `references/playbook.md`, and interface metadata in `agents/openai.yaml`.

**Responsibilities.** The PM selects the problem, segment, outcome, and next investment and validates value. The BA specifies the processes, rules, and verifiable requirements that realize that intent. Architecture selects the technical solution; QA verifies behavior. These are the package’s working boundaries, not a claim about every organization.

**Collaboration.** PM provides the problem statement, evidence, outcome, scope, and constraints. BA returns a specification, rules, exceptions, traceability, and open decisions. Architecture returns feasibility and trade-offs. The PM or authorized owner resolves product-scope implications; BA updates the baseline after a confirmed decision. Mentioning a role does not launch an agent or imply approval.

**Usage.** Copy an entire selected skill directory into your client’s supported skills directory, preserving the playbook link. Choose one language variant per role for a task; installing both is unnecessary for response translation. Registration and invocation depend on the client. For clients supporting `$skill-name`:

```text
$product-manager-en Assess whether this feature is worth building. Produce a decision brief, alternatives, and a test of the riskiest assumption.
$business-analyst-en Turn the agreed brief into processes, rules, exceptions, requirements, acceptance criteria, and a traceability matrix.
```

No scripts, network access, or specific tracker are mandatory. Current external claims require an available source; disclose unavailable access. Explicit language requests override defaults. Maintain behavioral and template parity across translations and update version metadata together. Example IDs are local and do not create tracker records.

**Validation.** Check YAML frontmatter, folder/name matching, relative links, interface metadata, RU/EN parity, and factual honesty. Static checks do not establish model performance; evaluate real tasks against explicit criteria before production use.

## Terminology and format references

These are primary references for the format, requirements classification, and RICE formula. The workflows, boundaries, templates, and examples above are original operating instructions, not a reproduction of a handbook or a certification claim.

- [Agent Skills specification](https://agentskills.io/specification)
- [IIBA: Understanding Requirements and Designs](https://www.iiba.org/knowledgehub/the-business-analysis-standard/4-implementing-business-analysis/4-4-understanding-requirements-and-designs/)
- [Intercom: RICE prioritization](https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/)

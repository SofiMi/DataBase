## Проект "Музыкальный ассистент"

**Предметная область:** база данных для музыкального приложения. 

**Цель использования:**
1) Поиск музыки по разным запросам (название, автор, жанр и т.д.).
2) Создание рекомендаций на основе предпочтений пользователя.
3) Анализ популярной музыки за последнее время.

**Сущности:**

1. `Users` 
В таблице описана информация о пользователях, которая влкючает в себя имя, возраст, место проживания и отметка времени, когда они скачали приложение.

2. `Songs`
Таблица, поддерживающая информацию о песнях: название, альбом, к которому она принадлежит, продолжительность.

3. `Views`
Описание прослушиваний песен пользователями. Также фиксируется дата записи. 

4. `Likes`
Описание понравившихся песен пользователям. Также фиксируется дата записи. 

6. `Albom`
В таблице имеется информация об имени альбома, дате выхода и добавления в приложение, авторе.

6. `Performers`
Содержится информация о музыкальных исполнителях: название группы, участники, страна и год создания, продолжает ли выступать.

7. `Genres`
Сущность содержит данные о музыкальных жанрах, такие как название, связанных направлениях музыки.
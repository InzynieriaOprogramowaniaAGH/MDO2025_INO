#include <stdio.h>
#include <stdlib.h>
#include <cjson/cJSON.h>

int main(void) {
    // Test działania biblioteki cJSON

    const char *json_string = "{\"comment\": \"Test poprawnej instalacji biblioteki cJSON\"}";

    // Parsowanie JSON-a na strukturę cJSON
    cJSON *root = cJSON_Parse(json_string);

    if (!root) {
        // Jeśli parsowanie się nie powiedzie, wypisz błąd i zakończ program
        printf("Error before: [%s]\n", cJSON_GetErrorPtr());
        return 1;
    }

    // Pobranie pola "comment" z obiektu JSON
    const cJSON *comment = cJSON_GetObjectItemCaseSensitive(root, "comment");

    // Sprawdzenie, czy pole "comment" istnieje i jest typu string
    if (cJSON_IsString(comment) && (comment->valuestring != NULL)) {
        printf("Komentarz: %s\n", comment->valuestring);
    }

    // Zwolnienie pamięci zaalokowanej dla obiektu JSON
    cJSON_Delete(root);
    return 0;
}

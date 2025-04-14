#include <stdio.h>
#include <stdlib.h>
#include <cjson/cJSON.h>

int main(void) {
    const char *json_string = "{\"name\": \"Adam\", \"programing language\": \"C\"}";

    cJSON *root = cJSON_Parse(json_string);
    if (!root) {
        printf("Error before: [%s]\n", cJSON_GetErrorPtr());
        return 1;
    }

    const cJSON *name = cJSON_GetObjectItemCaseSensitive(root, "name");
    if (cJSON_IsString(name) && (name->valuestring != NULL)) {
        printf("Name: %s\n", name->valuestring);
    }

    cJSON_Delete(root);
    return 0;
}

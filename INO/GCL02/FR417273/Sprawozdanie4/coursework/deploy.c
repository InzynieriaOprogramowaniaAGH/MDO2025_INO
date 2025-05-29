#include <stdio.h>
#include <cjson/cJSON.h>

int main() {
    const char *json = "{\"name\":\"Github Actions\",\"type\":\"CI\"}";
    cJSON *root = cJSON_Parse(json);

    if (root == NULL) {
        printf("Parse error\n");
        return 1;
    }

    cJSON *name = cJSON_GetObjectItemCaseSensitive(root, "name");
    if (cJSON_IsString(name) && (name->valuestring != NULL)) {
        printf("Parsed name: %s\n", name->valuestring);
    }

    cJSON_Delete(root);
    return 0;
}

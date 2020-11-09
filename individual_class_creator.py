import json

# Fall term for 2019-2020
with open('.vscode/grades.json') as f:
    data = json.load(f)

attribute_labels = ["Identifier", "Amount", "Course Title", "Credits", "GPA", "A (%)", "B (%)", "C (%)", "D (%)", "F (%)", "Withdraws", "Enrollment"]
individual_classes = []

def found(current_identifier, list_of_dicts):
    for i, d in enumerate(list_of_dicts):
        if current_identifier == d["Identifier"]:
            return i
    return -1

for item in data:
    found_index = found(item["Subject"] + "-" + str(item["Course No."]), individual_classes)
    if found_index != -1:
        index_of_dict = found_index
        individual_classes[index_of_dict]["Amount"] += 1
        non_sum_labels = attribute_labels[:4]
        for label in attribute_labels:
            if label not in non_sum_labels:
                individual_classes[index_of_dict][label] += item[label]
    else:
        build_dict = {"Identifier":(item["Subject"] + "-" + str(item["Course No."])), "Amount":1}
        for label in attribute_labels:
            if label not in build_dict:
                build_dict[label] = item[label]
        individual_classes.append(build_dict)

labels_to_divide = ["GPA", "A (%)", "B (%)", "C (%)", "D (%)", "F (%)"]
for entry in individual_classes:
    for label in labels_to_divide:
        entry[label] /= entry["Amount"]
        entry[label] = round(entry[label], 2)

raw_sort = sorted(individual_classes, key=lambda x:x["Course Title"], reverse=False)

with open('.vscode/individual_classes.json', 'w') as fout:
    json.dump(raw_sort , fout, indent=4)
print(len(individual_classes))
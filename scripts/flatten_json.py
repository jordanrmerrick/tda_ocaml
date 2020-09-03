import json
from os.path import dirname, join


def open_json(json_name):
    current_dir = dirname(__file__)
    file_path = join(current_dir, json_name)
    with open(file_path, "r") as json_file:
        data = json.load(json_file)
        return data


def flatten_json(y):
    out = {}

    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name=a)
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name)
                i += 1
        else:
            out[name] = x

    flatten(y)
    return out


def unformatted_list(json_):
    x = []
    keys = json_.keys()
    for key in keys:
        x.append(str(key))
    
    return x


def format_list(ul):
    s = "["
    for text in ul:
        s = s + " \"{}\";".format(text)
    s = s+"]"

    return s


def cycle_through_jsons(json_list):
    out = []

    for file in json_list:
        json_file = open_json(file)

        flattened_json = flatten_json(json_file)

        normal_list = unformatted_list(flattened_json)
        formatted_str = format_list(normal_list)

        out.append(formatted_str)

    return out

    
def write_to_text_file(outfile, ls):
    current_dir = dirname(__file__)
    file_path = join(current_dir, outfile)

    with open(file_path, 'w') as writer:
        for caml_list in ls:
            writer.write("%s\n" % caml_list)


ls = ["get_account.json", "get_instruments.json", "get_order.json", "get_orders_by_path.json", "get_orders_by_query.json",
      "get_saved_order.json", "get_saved_orders_by_path.json", "search_instruments.json"]
cycle = cycle_through_jsons(ls)
write_to_text_file("output.txt", cycle)


# Validation
def num_items(s):
    n = 0
    for i in range(len(s)):
        if s[i] == ";":
            n += 1
        else:
            pass
    return n
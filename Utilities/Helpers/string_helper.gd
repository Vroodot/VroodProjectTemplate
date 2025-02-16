class_name StringHelper

#region Constants
const AsciiAlphanumeric: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
const AsciiLetters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const AsciiLowercase: String = "abcdefghijklmnopqrstuvwxyz"
const AsciiUppercase: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const AsciiDigits: String = "0123456789"
const AsciiHexdigits: String = "0123456789ABCDEF"
const AsciiPunctuation: String =  "!\"#$%&'()*+, -./:;<=>?@[\\]^_`{|}~"
const bar: String = "█"
#endregion

static func adjust_text_in_label(label: Label, max_size: int = 200) -> void:
	label.custom_minimum_size.x = min(label.size.x, max_size)

	if label.size.x > max_size:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.custom_minimum_size.y = label.size.y

static func generate_random_string(length: int = 25, characters: String = AsciiAlphanumeric) -> String:
	var result := ""

	if(not characters.is_empty() && length > 0):
		for character in range(length):
			result += characters[Random.randi() % characters.length()]

	return result


## Converts PascalCaseString into pascal_case_string
static func camel_to_snake(camel_string: String) -> String:
	var snake_string := ""
	var previous_char := ""

	for c in camel_string:
		if c.to_upper() == c and previous_char != "" and previous_char.to_upper() != previous_char:
			snake_string += "_"
		snake_string += c.to_lower()
		previous_char = c

	return snake_string

## Converts pascal_case_string into PascalCaseString
static func snake_to_camel_case(screaming_snake_case: String) -> String:
	var words := screaming_snake_case.split("_")
	var camel_case := ""

	for i in range(words.size()):
		camel_case += words[i].capitalize()

	return camel_case


## Clean a string by removing characters that are not letters (uppercase or lowercase), numbers or spaces, tabs or newlines.
static func clean(string: String, include_numbers: bool = true) -> String:
	var regex = RegEx.new()

	if include_numbers:
		regex.compile("[\\p{L}\\p{N} ]*")
	else:
		regex.compile("[\\p{L} ]*")

	var result = ""
	var matches = regex.search_all(string)

	for m in matches:
		for s in m.strings:
			result += s

	return result

## This function wraps the provided text into multiple lines if it exceeds the specified max_line_length
static func wrap_text(text: String = "", max_line_length: int = 120):
	if text.is_empty() or text.length() <= max_line_length:
		return text
	else:
		var final_text: String = ""
		var words: PackedStringArray = text.split(" ")
		var current_line: String = ""

		for word: String in words:
			if current_line != "":
				if (current_line + word).length() + 1 > max_line_length:
					final_text += current_line + "\n"
					current_line = ""
				else:
					current_line += " "

			current_line += word

		final_text += current_line

		return final_text


static func integer_to_ordinal(number: int) -> String:
	var middle: int = number % 100
	var suffix: String = ""

	if middle >= 11 and middle <= 13:
		suffix = "th"
	else:
		suffix = {1: "st", 2: "nd", 3: "rd"}.get(number % 10, "th")

	return str(number) + suffix


static func pretty_number(number: float, suffixes: Array[String] = ["", "K", "M", "B", "T"]) -> String:
	var prefix_sign = "-" if sign(number) == -1 else ""

	number = absf(number)

	var exponent: int = 0

	while number >= 1000.0:
		number /= 1000.0  # Divide by 1000 for each exponent level
		exponent += 1

	# Round to one decimal place using snapped
	var formatted_number = str(snappedf(number, 0.001))

	return prefix_sign + formatted_number + suffixes[exponent]


static func to_binary_string(num: int) -> String:
	var binary_string: String= ""
	var number: int = num

	while number > 0:
		binary_string = str(number & 1) + binary_string
		number = number >> 1

	return binary_string


static func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")

	return regex.sub(source, "", true)


static func strip_filepaths(source: String) -> String:
	var regex = RegEx.new()
	regex.compile("res://([^ ])+")

	return regex.sub(source, "", true)


static func str_replace(target: String, regex: RegEx, cb: Callable) -> String:
	var result: String = ""
	var last_position: int = 0

	for regex_match in regex.search_all(target):
		var start := regex_match.get_start()
		result += target.substr(last_position, start - last_position)
		result += str(cb.call(regex_match.get_string()))
		last_position = regex_match.get_end()

	result += target.substr(last_position)

	return result


static func case_insensitive_comparison(one: String, two: String) -> bool:
	return one.strip_edges().to_lower() == two.strip_edges().to_lower()


static func is_whitespace(text: String) -> bool:
	var whitespace_regex: RegEx = RegEx.new()
	whitespace_regex.compile(r"\s+")

	if whitespace_regex.search(text):
		return true

	return false


static func remove_whitespaces(text: String) -> String:
	var whitespace_regex: RegEx = RegEx.new()
	whitespace_regex.compile(r"\s+")

	return StringHelper.str_replace(text, whitespace_regex, func(_text: String): return "")


static func repeat(text: String, times: int) -> String:
	var result: String = ""

	for i: int in range(times):
		result += text

	return result


static func bars(amount: int) -> String:
	return repeat(bar, amount)



#region BadWords
const Rules: Array[String] = [
	"n+([ehiy]+|ay|ey|io|[il]+)[bgq$]+h?(a+|aer|a+h+|a+r+|e+|ea|eoa|e+r+|ie|ier|let|lit|o|or|r+|u|uh|uhr|u+r+|ward|y+)s*",
	"f[ae]y?g+[oeiu]+t+s?",
	"даунская",
	"пидорасы",
	"ching\\W*chongs?",
	"n󠀡󠀡iggers",
	"re+t+a?r[dt]+s?",
	"towel\\W*heads?",
	"пидорка",
	"pac?k(i|ie|y)",
	"ting\\W*tongs?",
	"trann(ie|y)s?",
	"white\\W*trash",
	"ni:gg\\w*:\\w*",
	"chin(c|k)s?",
	"n+i+[gq]+s?",
	"yam\\W*yams?",
	"\\w*niggas?",
	"chinamans?",
	"polacke?s?",
	"neekeris?",
	"nigfhers?",
	"redskins?",
	"beaners?",
	"coolies?",
	"f+a+g+s*",
	"fenians?",
	"gringos?",
	"newfags?",
	"ni gg er",
	"nigga\\w*",
	"niggles?",
	"nignogs?",
	"rus+kis?",
	"wiggers?",
	"Ϝaggоt",
	"gypsies",
	"injuns?",
	"jiggas?",
	"nikkas?",
	"wiggas?",
	"\\w*fag",
	"coons?",
	"dykes?",
	"fa66ot",
	"fagts?",
	"gooks?",
	"gypos?",
	"homos?",
	"kikes?",
	"spics?",
	"abos?",
	"fgts?",
	"fаgs",
	"gypsy",
	"japs?",
	"wops?",
	"fagz",
	"fаg",
	"f@g",
	"\\w*N󠀡󠀡IGGE󠀡󠀡R\\w*",
	"\\w*ɴɪɢɢᴇʀ\\w*",
	"\\w*nіggеr\\w*",
	"\\w*NÍGGER\\w*",
	"\\w*n\\\\\\|gger\\w*",
	"\\w*niggеr\\w*",
	"\\w*F4GG0T\\w*",
	"\\w*N1GG3R\\w*",
	"\\w*nigger\\w*",
	"\\w*nigg4\\w*",
	"\\w*niggz\\w*",


	"fak(ed|ers?|ing)",
	"kompetenzteam",
	"æ´¾é€å‘˜",
	"pinegrove",
	"n\\.e\\.ig\\.e\\.",
	"fukushima",
	"nie gee",
	"fuchsia",
	"fuchian",
	"cock\\.li",
	"fuxius",
	"fucuro",
	"niego",
	"niebo",
	"neige",
	"neggy",
	"nebby",
	"fuxis",
	"cwfag",
	"pubg",
	"niby",
	"nebo",
	"fuku",
	"fuki",
	"fakt",

	"(ape|bat|bull?|butt|dip|dog|dumb|ebo|holy|horse|jack|pedo|pig|ubi)\\W*sh(it|ti)s?",
	"d[il]+(ck|kc)\\W*(ass|bag|breath|eat|face|flip|head|hole|less|suck|weed)\\w*",
	"f[chj]?(a|au|aw|e|o+|u|uy)[ch]*k(e?d|e?rs?|[ei]?n+g?|t)",
	"m[aou](d+|t+|th|ht|z)(a|e|er|ir|ur)(c|f)c?[aou]c?k\\w*",
	"m[ou]th(a|er)(f|ph)[vue]+c?[gkqx]+(e?d|e?r|[ei]?n+g?)",
	"\\w*f[vu]+h*c+[hjvk]*(e?d|e?r|[ei]?n+g?|t)",
	"b+i+a*t+c+h+(e+d|e*r?[sz]+|[ei]?n+g?|y)",
	"\\w*f[vu]+c?[xkq]+(e?d|e?r|[ei]?n+g?|t)",
	"p(oo+|u+)s+(a+y+|e+|eh|ey|i+|ie|y+)s*",
	"m[ou]th(a|er)(f|ph)[vue]+c?[gkqx]+",
	"\\w*f[vu]+h*q(e?d|e?r|[ei]?n+g?|t)",
	"f[chj]?(a|au|aw|e|o+|u|uy)[ch]*k",
	"f[ck]+(e?d|e?r|[ei]?n+g?|t)",
	"fu󠀡󠀡cki󠀡󠀡ng",
	"dumb(f|ph)[vu]+c?[xkq]",
	"c(oc?|aw)k\\W*suc?k\\w*",
	"d[il]+(ck|kc)(ed|ing)",
	"ph[vu]+h*c+[hjvk]*\\w*",
	"son\\W*of\\W*a\\W*bitch",
	"долбоебизм",
	"c(o|ah|aw)c?k(s|ed)",
	"s+h+[ily]+t+[ersy]*",
	"a+ss+\\W*w?hole?\\w*",
	"ph[vu]+c?[xkq]+\\w*",
	"говноедов",
	"долбаебов",
	"ебланская",
	"ебланский",
	"заебёшься",
	"захуячили",
	"съебаться",
	"пидарский",
	"уебанский",
	"уебищьное",
	"f[vu]+c?[xkq]+\\w*",
	"bull+sh+[ily]+t+",
	"god\\W*damn?\\W*it",
	"ахуенная",
	"ахуенную",
	"ахуенный",
	"выебаное",
	"ебанному",
	"ебанутые",
	"ебланами",
	"пидарасы",
	"уёбищная",
	"уёбищный",
	"god\\W*damn?\\w*",
	"въебали",
	"въебать",
	"ебанная",
	"ебанное",
	"ебанных",
	"ебаного",
	"ебаньки",
	"ебонное",
	"заебала",
	"заебало",
	"поебень",
	"хуёвого",
	"a+ss+\\W*fu\\w*",
	"c(o|ah|aw)c?k",
	"d[il]+(ck|kc)",
	"b+i+a*t+c+h+",
	"butt\\W*fu\\w*",
	"cumm(er|ing)",
	"f[vu]+h*c\\w*",
	"f[vu]+h*q\\w*",
	"sh+i+[ae]+t+",
	"ахуели",
	"ебаная",
	"ебаное",
	"ебаной",
	"ебаную",
	"ебаные",
	"ебаный",
	"ебаным",
	"ебаных",
	"ебучий",
	"пиздеж",
	"пиздец",
	"сраная",
	"уёбища",
	"уёбище",
	"хуесос",
	"хуетой",
	"хуйнёй",
	"хуёвая",
	"хуёвый",
	"c+u+n+t+\\w*",
	"d+i+c+k+s*",
	"fucking",
	"блядь",
	"блять",
	"дохуя",
	"дрочи",
	"ебало",
	"ебать",
	"н4еб4л",
	"нахуй",
	"нахуя",
	"нехуй",
	"нихуя",
	"пизде",
	"пизду",
	"похуй",
	"уебёт",
	"хуета",
	"хуету",
	"хуйни",
	"хуйню",
	"хуйня",
	"ёбаны",
	"a+sholes?",
	"sh+e+i+t+",
	"ахуе",
	"ебал",
	"ебут",
	"сука",
	"хуям",
	"шлюх",
	"F\\.U\\.C\\.K",
	"chodes?",
	"cumshot",
	"fucking",
	"fuck",
	"shit\\w*",
	"shtpost",
	"who+re?",
	"cumbag",
	"jebane",
	"sluts?",
	"slutty",
	"twats?",
	"бля",
	"ебу",
	"хуи",
	"хуй",
	"хуя",
	"cums?",
	"dafuq",
	"diсk",
	"sh it",
	"coq+",
	"hore",
	"kock",
	"shat",
	"dik",
	"fck",
	"\\w*f+u+c+k+\\w*",
	"\\w*fцск\\w*",
	"\\w*shіtty\\w*",
	"\\w*f_uc_k\\w*",
	"^[a@][s\\$][s\\$]$",
	"[a@][s\\$][s\\$]h[o0][l1][e3][s\\$]?",
	]
#endregion

static func censor_list(texts: Array[String] = [], censor_character: String = "*") -> Array[String]:
	var censored_texts: Array[String] = []

	for text in texts:
		censored_texts.append(censor(text, censor_character))

	return censored_texts


static func censor(text: String, censor_character: String = "*") -> String:
	var new_text: String = text
	var regex = RegEx.new()

	for rule in Rules:
		regex.compile(rule)

		var result: RegExMatch = regex.search(new_text)

		if is_instance_valid(result):
			for profanity in result.strings:
				var censored_string: String = ""

				for _i in profanity.length():
					censored_string += censor_character

				new_text = new_text.replace(profanity, censored_string)

	return new_text

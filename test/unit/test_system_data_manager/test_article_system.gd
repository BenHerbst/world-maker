extends RootSystemTest

var _temp_resource:Resource    = preload("res://test/resources_and_temp_items/temp_test_resource.tres")

# === BEFORE ===

func test_make_new_file():
	var uuid = ArticleSystem.make_new_article(
		"home",
		"xyz",
		"xyz",
		2,
		Resource.new(),
		"sample text",
		"",
		"",
		[
			"home",
			"safe",
			"country side"
		]
	)

	yield(get_tree().create_timer(0.5), "timeout")

	# asserstions

	var _x = ResourceManager.open_file(uuid, ResourceManager.ARTICLE)

	assert_file_exists("res://save_files/articles/{uid}_save_data.tres".format({"uid" : uuid}))
	assert_eq(_x.article_name, "home")
	assert_eq(_x.article_id, uuid)
	assert_eq(_x.article_banner, "xyz")
	assert_eq(_x.article_profile, "xyz")
	assert_eq(_x.article_type, 2)
	assert_eq(_x.article_raw, "sample text")
	assert_eq_deep(_x.tags, ["home", "safe", "country side"])

	
func test_add_remove_tags():
	var uuid = ArticleSystem.make_new_article(
		"home",
		"xyz",
		"xyz",
		1,
		Resource.new(),
		"sample text",
		"",
		"",
		[
			"home",
			"safe",
			"country side"
		]
	)
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	var _y = ResourceManager.open_file(uuid, ResourceManager.ARTICLE)
	assert_eq_deep(_y.tags, ["home", "safe", "country side"])

	ArticleSystem.add_tags(uuid, ["book store", "city"])
	var _x = ResourceManager.open_file(uuid, ResourceManager.ARTICLE)

	assert_file_exists("res://save_files/articles/{uid}_save_data.tres".format({"uid" : uuid}))
	assert_eq(_x.article_name, "home")
	assert_eq(_x.article_id, uuid)
	assert_eq(_x.article_banner, "xyz")
	assert_eq(_x.article_profile, "xyz")
	assert_eq(_x.article_type, 1)
	assert_eq(_x.article_raw, "sample text")
	assert_eq_deep(_x.tags, ["home", "safe", "country side", "book store", "city"])

	ArticleSystem.remove_tags(uuid, ["home", "safe", "country side"])
	var _z = ResourceManager.open_file(uuid, ResourceManager.ARTICLE)
	assert_eq_deep(_z.tags, ["book store", "city"])

func test_fetch_article_by_tags_name():
	var uuid_1 = ArticleSystem.make_new_article(
		"home",
		"xyz",
		"xyz",
		1,
		Resource.new(),
		"sample text",
		"",
		"",
		[
			"home",
			"safe",
			"country side"
		]
	)

	var uuid_2 = ArticleSystem.make_new_article(
		"shop",
		"xyz",
		"xyz",
		1,
		Resource.new(),
		"sample text",
		"",
		"",
		[
			"home",
			"country side"
		]
	)
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	assert_file_exists("res://save_files/articles/{uid}_save_data.tres".format({"uid" : uuid_1}))
	assert_file_exists("res://save_files/articles/{uid}_save_data.tres".format({"uid" : uuid_2}))

	var pins_1:Array = ArticleSystem.get_articles_with_tag("safe")
	
	assert_eq(1, pins_1.size())
	assert_eq_deep([load("res://save_files/articles/{uid}_save_data.tres".format({"uid" : uuid_1}))], pins_1)
	
	var pins_2:Array = ArticleSystem.get_articles_with_tag("home")
	
	assert_eq(2, pins_2.size())
	assert_true(pins_2.has(load("res://save_files/articles/{uid}_save_data.tres".format({"uid" : uuid_1}))))
	assert_true(pins_2.has(load("res://save_files/articles/{uid}_save_data.tres".format({"uid" : uuid_2}))))

return {
	descriptions = {
		Joker = {
			j_jank_pawn = {
				name = "当铺小丑",
				text = {
					"售出卡牌时",
                    "有{C:green}#1#/#2#{}的几率",
                    "获得{C:attention}$#3#"
				},
			},
			j_jank_expanded_art = {
				name = "小丑半身像",
				text = {
					"{C:attention}增强卡牌{}在计分时",
                    "给予{C:chips}+#1#{}筹码"
				},
			},
			j_jank_self_portrait = {
				name = "自画像",
				text = {
					"{C:attention}#1#{}时",
                    "本牌获得{X:mult,C:white}X0.1{}倍率",
                    "每个盲注改变上述要求",
                    "{C:inactive}（当前为{X:mult,C:white}X#2#{C:inactive}倍率）"
				},
			},
			j_jank_mural_menace = {
				name = "墙面涂鸦",
				text = {
					"跳过{C:attention}盲注{}时",
					"随机生成一个{C:attention}标签",
				},
			},
			j_jank_minimalist = {
				name = "极简小丑",
				text = {
					"若打出的牌",
                    "不包含{C:attention}人头牌",
                    "{C:mult}+#1#{}倍率"
				},
			},
			j_jank_devoted = {
				name = "奉献小丑",
				text = {
					"选择{C:attention}Boss盲注{}时",
                    "本牌获得{X:mult,C:white}X#2#{}倍率",
                    "并使{C:attention}资金{C:attention}归零",
                    "{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}倍率）"
				},
			},
			j_jank_ternary_system = {
				name = "三星连珠",
				text = {
					"如果正好打出{C:attention}3{}张牌",
                    "且牌型为{C:attention}三条",
                    "生成一张{C:planet}星球牌",
                    "{C:inactive}（必须有空位）"
				},
			},
			j_jank_stanczyk = {
				name = "斯坦奇克",
				text = {
					"重新触发所有打出的",
                    "和手牌中的{C:attention}增强卡牌"
				},
			},
			j_jank_cut_the_cheese = {
				name = "切奶酪",
				text = {
					"选择{C:attention}盲注{}时",
                    "随机生成一张{C:attention}食物小丑牌",
                    "{C:inactive}（必须有空位）"
				},
			},
			j_jank_boredom_slayer = {
				name = "无聊终结者",
				text = {
					"出牌时，使{C:attention}盲注{}的",
                    "最低得分要求",
                    "削减{C:attention}#1#%"
				},
			},
			j_jank_fortuno = {
				name = "佛尔图诺",
				text = {
					"摧毁每回合第一次出牌中",
                    "所有的{C:attention}数字牌",
                    "每摧毁一张给予{C:attention}$#1#"
				},
			},
			j_jank_chalk_outline = {
				name = "凶案现场",
				text = {
					"{C:attention}最后一次出牌{}时",
                    "本牌获得{C:mult}+6{}倍率",
                    "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
				},
			},
			j_jank_memorable = {
				name = "小丑记忆之链",
				text = {
					"如果打出的牌正好是{C:attention}3{}张",
                    "本牌获得{X:mult,C:white}X#2#{}倍率",
                    "不合要求的出牌将重置倍率",
                    "{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}倍率）"
				},
			},
			j_jank_scrapper = {
				name = "好斗小丑",
				text = {
					"有{C:green}#1#/#2#{}的几率",
                    "在弃掉五张{C:attention}数字{}牌时",
                    "随机生成一张{C:attention}星球牌"
				},
			},
			j_jank_lieutenant = {
				name = "小丑中尉",
				text = {
					"打出{C:attention}高牌{}后",
                    "提升每张牌的{C:attention}点数"
				},
			},
			j_jank_sunday_funnies = {
				name = "周日乐淘淘",
				text = {
					"在商店中每{C:attention}重掷{}两次",
                    "随机生成一张{C:planet}星球牌{}或{C:tarot}塔罗牌",
                    "{C:inactive}（必须有空位）",
                    "{C:inactive}（还需重掷{C:green}#1#{C:inactive}次）"
				},
			},
			j_jank_box_of_stuff = {
				name = "拆封快递",
				text = {
					"选择{C:attention}Boss盲注{}时",
                    "免费生成三个{C:attention}标准标签",
                    "并摧毁本牌"
				},
			},
			j_jank_sentai = {
				name = "超级战队小丑",
				text = {
					"每使用一张{C:attention}星球牌",
                    "获得{C:mult}+#2#{}倍率",
                    "击败{C:attention}Boss盲注{}后重置",
                    "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
				},
			},
			j_jank_old_man = {
				name = "老叟小丑",
				text = {
					"选择{C:attention}Boss盲注{}时",
                    "免费生成一个{C:attention}空灵标签"
				},
			},
			j_jank_cardslinger = {
				name = "飞牌大师",
				text = {
					"当前出牌中",
                    "每有一张计分的牌",
                    "{C:chips}+#1#{}筹码"
				},
			},
			j_jank_shady_dealer = {
				name = "不法商贩",
				text = {
					"售出本牌即可免费",
                    "生成一个{C:attention}负片标签"
				},
			},
			j_jank_feste = {
				name = "费斯特",
				text = {
					"将在{C:attention}Boss盲注{}中",
                    "第一次出牌的牌型",
                    "提升{C:attention}#1#{}个等级"
				},
			},
			j_jank_chicken_scratch = {
				name = "鸡爪挠地",
				text = {
					"打出{C:attention}8{}、{C:attention}7{}或{C:attention}3{}并计分时",
                    "本牌获得{C:chips}+#2#{}筹码",
                    "{C:inactive}（当前为{C:chips}+#1#{C:inactive}筹码）"
				},
			},
			j_jank_devilish = {
				name = "恶魔小丑",
				text = {
					"如果打出的牌中",
                    "仅包含{C:attention}6{}或{C:attention}黄金牌",
                    "{X:mult,C:white}X#1#{}倍率"
				},
			},
			j_jank_pitiful = {
				name = "凄惨小丑",
				text = {
					"若出牌牌型为",
                    "{C:attention}高牌{}或{C:attention}对子",
                    "{C:mult}+#1#{}倍率"
				},
			},
			j_jank_tapestry = {
				name = "挂毯小丑",
				text = {
					"本赛局内每使用过一{C:attention}种{}消耗牌",
                    "本牌获得{C:mult}+#2#{}倍率",
                    "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
				},
			},
			j_jank_wanted_poster = {
				name = "通缉令",
				text = {
					"若第一次出牌",
                    "即击败{C:attention}盲注",
                    "获得{C:money}$#1#",
                    "否则每多出一次牌",
                    "失去{C:attention}$#2#"
				},
			},
			j_jank_midnight_crew = {
				name = "午夜帮",
				text = {
					"打出{V:1}#1#{C:attention}同花{}并计分时",
                    "本牌获得{X:mult,C:white} X0.5 {}倍率",
                    "击败盲注后改变需求花色",
                    "{C:inactive}（当前为{X:mult,C:white}X#2#{C:inactive}）"
				},
			},
			j_jank_makeshift = {
				name = "拼凑小丑",
				text = {
					"每售出一张{C:attention}卡牌",
                    "本牌获得{C:mult}+#2#{}倍率",
                    "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
				},
			},
			j_jank_sir = {
				name = "小丑爵士",
				text = {
					"在{C:attention}Boss盲注{}中",
                    "或{C:attention}最后一次出牌{}计分时",
                    "{X:mult,C:white}X#1#{}倍率"
				},
			},
			j_jank_suspicious_vase = {
				name = "蹊跷花瓶",
				text = {
					"打出的所有{C:attention}2{}、{C:attention}3{}和{C:attention}4",
                    "均变为{C:attention}玻璃牌",
                    "且可给予{X:mult,C:white} X#1# {}倍率"
				},
			},
			j_jank_impractical = {
				name = "即兴整蛊小丑",
				text = {
					"如果打出的{C:attention}牌型{}为{C:attention}#1#{}，{X:mult,C:white}X#2#{}倍率",
                    "触发后改变需求牌型"
				},
			},
			j_jank_highlander = {
				name = "高地小丑",
				text = {
					"若出牌牌型为{C:attention}高牌",
                    "每张计分的牌",
                    "永久获得{C:chips}+#1#{}筹码"
				},
			},
			j_jank_jevil = {
				name = "丑魔",
                text = {
                    "{C:attention}同花顺{}在计分时",
                    "给予{C:chips}+1{}筹码"
                }
			}
		},
	},
	misc = {
		challenge_names = {
			c_jankch_pawnshop = "典当行",
			c_jankch_LoJ = "金宝传奇故事",
		},
		dictionary = {
			self_portrait_1 = "使用塔罗牌",
            self_portrait_2 = "使用星球牌",
            self_portrait_3 = "卡牌被摧毁",
            self_portrait_4 = "打出的牌少于等于3张",
            self_portrait_5 = "弃掉大于等于3张人头牌",
            self_portrait_6 = "打出高牌",
            self_portrait_7 = "打出顺子",
            self_portrait_8 = "打出同花",
		}
	}
}
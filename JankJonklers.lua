--- STEAMODDED HEADER
--- MOD_NAME: JankJonklersMod
--- MOD_ID: JankJonklersMod
--- MOD_AUTHOR: [Lyman]
--- MOD_DESCRIPTION: Adds a bunch of Jank Jonklers.
--- BADGE_COLOUR: 66AB05
--- DISPLAY_NAME: Jank Jonklers

----------------------------------------------
------------MOD CODE -------------------------

--add mind mage after you rework it, dummy!
-- jevil does nothing! yet
local config = {
    j_fortuno = true,
    j_stanczyk = true,
    j_feste = true,
    j_jevil = false,
    j_midnight_crew = true,
    j_sir = true,
    j_devilish = true,
    j_impractical = true,
    j_wanted_poster = true,
    j_sentai = true,
    j_makeshift = true,
    j_pitiful = true,
    j_ternary_system = true,
    j_minimalist = true,
    j_devoted = true,
    j_pawn = true,
    j_scrapper = true,
    j_old_man = true,
    j_box_of_stuff = true,
    j_expanded_art = true,
    j_highlander = true,
    j_lieutenant = true,
    j_cut_the_cheese = true,
    j_shady_dealer = true,
    j_suspicious_vase = true,
    j_mural_menace = true,
    j_chicken_scratch = true,
    j_chalk_outline = true,
    j_boredom_slayer = true,
    j_cardslinger = true,
    j_sunday_funnies = true,
    j_self_portrait = true,
    j_memorable = true,
    j_tapestry = true,
}
-- thank you mika for this code!!!
local function init_joker(joker, no_sprite)
    no_sprite = no_sprite or false

    local joker = SMODS.Joker:new(
        joker.ability_name,
        joker.slug,
        joker.ability,
        { x = 0, y = 0 },
        joker.loc,
        joker.rarity,
        joker.cost,
        joker.unlocked,
        joker.discovered,
        joker.blueprint_compat,
        joker.eternal_compat,
        joker.effect,
        joker.atlas,
        joker.soul_pos
    )
    joker:register()
    if not no_sprite then
        local sprite = SMODS.Sprite:new(
            joker.slug,
            SMODS.findModByID("JankJonklersMod").path,
            joker.slug .. ".png",
            71,
            95,
            "asset_atli"
        )
        sprite:register()
    end
end

local function get_suit(card)
    if card.ability.effect == 'Stone Card' and not card.vampired then
        return -math.random(100, 100000)
    end
    return card.base.suit
end

function SMODS.INIT.JankJonklersMod()
    init_localization()

    -- Fortuno
    if config.j_fortuno then
        local fortuno = {
            loc = {
                name = "Fortuno",
                text = {
                    "For each {C:attention}numbered card{} scored",
                    "in your first hand each round,",
                    "destroy it and gain {C:attention}$3{}"
                }
            },
            ability_name = "Fortuno",
            slug = "fortuno",
            ability = {
                extra = {
                    dollars = 3,
                    trash_list = {}
                },
            },
            rarity = 4,
            cost = 20,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = true,
            soul_pos = { x = 1, y = 0 }
        }
        -- Initialize Joker
        init_joker(fortuno)
        -- Set local variables
        function SMODS.Jokers.j_fortuno.loc_def(card)
            return { card.ability.extra.dollars }
        end
        -- Calculate
        SMODS.Jokers.j_fortuno.calculate = function(self, context)
            if context.before and context.cardarea == G.jokers and not context.blueprint and G.GAME.current_round.hands_played == 0 then
                for k, v in ipairs(context.scoring_hand) do
                    if not (v:is_face() or v:get_id() == 14) then
                        table.insert(self.ability.extra.trash_list, v)
                        local card_to_destroy = v
                        card_to_destroy.getting_sliced = true
                        card_to_destroy:start_dissolve()
                        ease_dollars(self.ability.extra.dollars)
                    end
                end
                return {
                    message = localize('$')..self.ability.extra.dollars,
                    colour = G.C.MONEY,
                    delay = 0.45, 
                    remove = true,
                    card = self
                }
            elseif context.end_of_round then
                if not context.blueprint and not context.repetition then
                    for i = 1, #self.ability.extra.trash_list do
                        self.ability.extra.trash_list[i]:start_dissolve(nil, true, 0, true)
                    end
                    self.ability.extra.trash_list = {}
                end
            end
        end
    end

    -- Stańczyk
    if config.j_stanczyk then
        local stanczyk = {
            loc = {
                name = "斯坦奇克",
                text = {
                    "重新触发所有打出的",
                    "和手牌中的{C:attention}增强卡牌"
                }
            },
            ability_name = "Stańczyk",
            slug = "stanczyk",
            ability = {
                extra = {
                    loop_amount = 1,
                },
            },
            rarity = 4,
            cost = 20,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
            soul_pos = { x = 1, y = 0 }
        }
        -- Initialize Joker
        init_joker(stanczyk)
        -- Set local variables
        function SMODS.Jokers.j_stanczyk.loc_def(card)
            return { card.ability.extra.loop_amount }
        end
        -- Calculate
        SMODS.Jokers.j_stanczyk.calculate = function(self, context)
            if context.repetition and context.cardarea == G.play then
                if context.other_card.ability.set == 'Enhanced' and not context.other_card.debuff then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = 1,
                        card = self
                    }
                end
            end
            if context.repetition and context.cardarea == G.hand then
                if context.other_card.ability.set == 'Enhanced' and (next(context.card_effects[1]) or #context.card_effects > 1) and not context.other_card.debuff then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = 1,
                        card = self
                    }
                end
            end
        end
    end

    -- Feste
    if config.j_feste then
        local feste = {
            loc = {
                name = "费斯特",
                text = {
                    "将在{C:attention}Boss盲注{}中",
                    "第一次出牌的牌型",
                    "提升{C:attention}4{}个等级"
                }
            },
            ability_name = "Feste",
            slug = "feste",
            ability = {
                extra = {
                    extra = 4,
                },
            },
            rarity = 4,
            cost = 20,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
            soul_pos = { x = 1, y = 0 }
        }
        -- Initialize Joker
        init_joker(feste)
        -- Set local variables
        function SMODS.Jokers.j_feste.loc_def(card)
            return { card.ability.extra }
        end
        -- Calculate
        SMODS.Jokers.j_feste.calculate = function(self, context)
            if context.before then
                if G.GAME.current_round.hands_played == 0 and G.GAME.blind.boss then
                    level_up_hand(self, context.scoring_name, false, 4)
                    return {
                        card = self,
                        message = localize('k_level_up_ex')
                    }
                end
            end
        end
    end

    -- Jevil
    if config.j_jevil then
        local jevil = {
            loc = {
                name = "Jevil",
                text = {
                    "{C:attention}Straight Flushes{} give",
                    "{C:chips}+1{} Chips when scored"
                }
            },
            ability_name = "Jevil",
            slug = "jevil",
            ability = {
                extra = {
                    extra = 4,
                },
            },
            rarity = 4,
            cost = 20,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
            soul_pos = { x = 1, y = 0 }
        }
        -- Initialize Joker
        init_joker(jevil)
        -- Set local variables
        function SMODS.Jokers.j_jevil.loc_def(card)
            return { card.ability.extra }
        end
        -- Calculate
        SMODS.Jokers.j_jevil.calculate = function(self, context)
            if context.before then
                if G.GAME.current_round.hands_played == 0 and G.GAME.blind.boss then
                    level_up_hand(self, context.scoring_name, false, 4)
                    return {
                        card = self,
                        message = localize('k_level_up_ex')
                    }
                end
            end
        end
    end

    -- Midnight Crew
    if config.j_midnight_crew then
        local midnight_crew = {
            loc = {
                name = "午夜帮",
                text = {
                    "打出{V:1}#1#{C:attention}同花{}并计分时",
                    "本牌获得{X:mult,C:white} X0.5 {}倍率",
                    "击败盲注后改变需求花色",
                    "{C:inactive}（当前为{X:mult,C:white}X#2#{C:inactive}）"
                }
            },
            ability_name = "Midnight Crew",
            slug = "midnight_crew",
            ability = {
                extra = {
                    suit = "Spades",
                    x_mult = 1,
                },
            },
            rarity = 4,
            cost = 20,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
            soul_pos = { x = 1, y = 0 }
        }
        -- Initialize Joker
        init_joker(midnight_crew)
        -- Set local variables
        function SMODS.Jokers.j_midnight_crew.loc_def(card)
            return { localize(card.ability.extra.suit,"suits_plural"), card.ability.extra.x_mult, colours = {G.C.SUITS[card.ability.extra.suit]} }
        end
        -- Calculate
        SMODS.Jokers.j_midnight_crew.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                if context.scoring_name == "Flush" or context.scoring_name == "Straight Flush" or context.scoring_name == "Royal Flush" or context.scoring_name == "Flush Five" or context.scoring_name == "Flush House" then
                    local isFlushSuit = true
                    for k, v in ipairs(context.full_hand) do
                        isFlushSuit = isFlushSuit and get_suit(v) == self.ability.extra.suit
                    end
                    if isFlushSuit then
                        if not context.blueprint then
                            self.ability.extra.x_mult = self.ability.extra.x_mult + 0.5
                        end
                        return {
                            message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.x_mult } },
                            Xmult_mod = self.ability.extra.x_mult
                        }
                    end
                end
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.x_mult } },
                    Xmult_mod = self.ability.extra.x_mult
                }
            end
            if context.end_of_round and not context.blueprint and not (context.individual or context.repetition) then
                local midnight_suits = {"Spades", "Diamonds", "Hearts", "Clubs"}
                local midnight_picker = pseudorandom_element({1, 2, 3, 4}, pseudoseed('midnight_crew'))
                self.ability.extra.suit =  midnight_suits[midnight_picker]
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('tarot1')
                    self:juice_up(0.3, 0.5)
                    SMODS.Jokers.j_midnight_crew.soul_pos.x = midnight_picker
                    self:set_sprites(self.config.center)
                    return true end }))
            end
        end
    end

    -- Devilish Joker
    if config.j_devilish then
        -- Create Joker
        local devilish = {
            loc = {
                name = "恶魔小丑",
                text = {
                    "如果打出的牌中",
                    "仅包含{C:attention}6{}或{C:attention}黄金牌",
                    "{X:mult,C:white}X3{}倍率"
                }
            },
            ability_name = "Devilish Joker",
            slug = "devilish",
            ability = {
                extra = {
                    x_mult = 3
                }
            },
            rarity = 2,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(devilish)
        -- Set local variables
        function SMODS.Jokers.j_devilish.loc_def(card)
            return { card.ability.extra.x_mult }
        end
        -- Calculate
        SMODS.Jokers.j_devilish.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                local onlySixes = true
                for k, v in ipairs(context.full_hand) do
                    onlySixes = onlySixes and (v:get_id() == 6 or v.ability.name == 'Gold Card')
                end
                if not onlySixes then
                    return nil
                end
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.x_mult } },
                    Xmult_mod = self.ability.extra.x_mult
                }
            end
        end
    end

    -- Impractical Joker
    if config.j_impractical then
        -- Create Joker
        local impractical = {
            loc = {
                name = "即兴整蛊小丑",
                text = {
                    "如果打出的{C:attention}牌型{}为{C:attention}#1#{}，{X:mult,C:white}X3{}倍率",
                    "触发后改变需求牌型"
                }
            },
            ability_name = "Impractical Joker",
            slug = "impractical",
            ability = {
                extra = { 
                    x_mult = 3,
                    poker_hand = "High Card", }
            },
            rarity = 2,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(impractical)
        -- Set local variables
        function SMODS.Jokers.j_impractical.loc_def(card)
            return { G.localization.misc['poker_hands'][card.ability.extra.poker_hand] }
        end
        -- Calculate
        SMODS.Jokers.j_impractical.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                if context.scoring_name == self.ability.extra.poker_hand then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local _poker_hands = {}
                            for k, v in pairs(G.GAME.hands) do
                                if v.visible and k ~= self.ability.to_do_poker_hand then _poker_hands[#_poker_hands+1] = k end
                            end
                            self.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('to_do'))
                            return true
                        end
                    })) 
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.x_mult } },
                        Xmult_mod = self.ability.extra.x_mult
                    }
                end
            end
        end
    end

    -- Impractical Joker
    if config.j_wanted_poster then
        -- Create Joker
        local wanted_poster = {
            loc = {
                name = "通缉令",
                text = {
                    "若第一次出牌",
                    "即击败{C:attention}盲注",
                    "获得{C:money}$10",
                    "否则每多出一次牌",
                    "失去{C:attention}$2"
                }
            },
            ability_name = "Wanted Poster",
            slug = "wanted_poster",
            ability = {
                extra = { 
                    dollars = 10,
                    penalty = 2, }
            },
            rarity = 2,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(wanted_poster)
        -- Set local variables
        function SMODS.Jokers.j_wanted_poster.loc_def(card)
            return { card.ability.extra.dollars }
        end
        -- Calculate
        SMODS.Jokers.j_wanted_poster.calculate = function(self, context)
            if context.cardarea == G.jokers then
                if context.before then
                    if G.GAME.current_round.hands_played >= 1 then
                        ease_dollars(-self.ability.extra.penalty)
                        return {
                            message = localize('$')..self.ability.extra.penalty,
                            colour = G.C.MONEY,
                            delay = 0.45, 
                            remove = true,
                            card = self
                        }
                    end
                end
            end
        end
    end

    -- Sentai Joker
    if config.j_sentai then
        -- Create Joker
        local sentai = {
            loc = {
                name = "超级战队小丑",
                text = {
                    "每使用一张{C:attention}星球牌",
                    "获得{C:mult}+8{}倍率",
                    "击败{C:attention}Boss盲注{}后重置",
                    "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
                }
            },
            ability_name = "Sentai Joker",
            slug = "sentai",
            ability = {
                extra = {
                    mult = 8
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(sentai)
        -- Set local variables
        function SMODS.Jokers.j_sentai.loc_def(card)
            return { card.ability.extra.mult }
        end
        -- Calculate
        SMODS.Jokers.j_sentai.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers and self.ability.mult > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                    mult_mod = self.ability.mult + self.ability.extra.mult
                }
            elseif context.using_consumeable then
                if not context.blueprint and context.consumeable.ability.set == 'Planet' then
                    self.ability.mult = self.ability.mult + self.ability.extra.mult
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={self.ability.mult}}}); return true
                        end}))
                    return
                end
            elseif context.end_of_round and not context.blueprint then
                if G.GAME.blind.boss and self.ability.mult > 1 then
                    self.ability.mult = 0
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED
                    }
                end
            end
        end
    end


    -- Makeshift Joker
    if config.j_makeshift then
        -- Create Joker
        local makeshift = {
            loc = {
                name = "拼凑小丑",
                text = {
                    "每次售出{C:attention}卡牌",
                    "本牌获得{C:mult}+1{}倍率",
                    "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
                }
            },
            ability_name = "Makeshift Joker",
            slug = "makeshift",
            ability = {
                extra = {
                    mult = 0
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(makeshift)
        -- Set local variables
        function SMODS.Jokers.j_makeshift.loc_def(card)
            return { card.ability.mult }
        end
        -- Calculate
        SMODS.Jokers.j_makeshift.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers and self.ability.mult > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                    mult_mod = self.ability.mult + self.ability.extra.mult
                }
            elseif context.selling_card then
                if not context.blueprint then
                    self.ability.mult = self.ability.mult + 1
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={self.ability.mult}}}); return true
                        end}))
                    return
                end
            end
        end
    end


    -- Pitiful Joker
    if config.j_pitiful then
        -- Create Joker
        local pitiful = {
            loc = {
                name = "凄惨小丑",
                text = {
                    "如果打出的牌型为",
                    "{C:attention}高牌{}或{C:attention}对子",
                    "{C:mult}+10{}倍率"
                }
            },
            ability_name = "Pitiful Joker",
            slug = "pitiful",
            ability = {
                extra = {
                    mult = 10
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(pitiful)
        -- Set local variables
        function SMODS.Jokers.j_pitiful.loc_def(card)
            return { card.ability.extra.mult }
        end
        -- Calculate
        SMODS.Jokers.j_pitiful.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers and (context.scoring_name == "High Card" or context.scoring_name == "Pair") then
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                }
            end
        end
    end

    -- Ternary System
    if config.j_ternary_system then
        -- Create Joker
        local ternary_system = {
            loc = {
                name = "三星连珠",
                text = {
                    "如果正好打出{C:attention}3{}张牌",
                    "且牌型为{C:attention}三条",
                    "生成一张{C:planet}星球牌",
                    "{C:inactive}（必须有空位）"
                }
            },
            ability_name = "Ternary System",
            slug = "ternary_system",
            ability = {
                extra = {
                    poker_hand = 'Three of a Kind'
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(ternary_system)
        -- Set local variables
        function SMODS.Jokers.j_ternary_system.loc_def(card)
            return { card.ability.extra.poker_hand }
        end
        -- Calculate
        SMODS.Jokers.j_ternary_system.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    if #context.full_hand == 3 then
                        if next(context.poker_hands[self.ability.extra.poker_hand]) then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = (function()
                                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                    return true
                                end)}))
                            return {
                                message = localize('k_plus_planet'),
                                colour = G.C.SECONDARY_SET.Planet,
                                card = self
                            }
                        end
                    end
                    return nil
                end
            end
        end
    end

    -- Minimalist Joker
    if config.j_minimalist then
        -- Create Joker
        local minimalist = {
            loc = {
                name = "极简小丑",
                text = {
                    "若打出的牌",
                    "不包含{C:attention}人头牌",
                    "{C:mult}+10{}倍率"
                }
            },
            ability_name = "Minimalist Joker",
            slug = "minimalist",
            ability = {
                extra = {
                    mult = 10
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(minimalist)
        -- Set local variables
        function SMODS.Jokers.j_minimalist.loc_def(card)
            return { card.ability.extra.mult }
        end
        -- Calculate
        SMODS.Jokers.j_minimalist.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                local CheckForFaces = true
                for k, v in ipairs(context.full_hand) do
                    CheckForFaces = CheckForFaces and not v:is_face()
                end
                if not CheckForFaces then
                    return nil
                end
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                }
            end
        end
    end

    -- Devoted Joker
    if config.j_devoted then
        -- Create Joker
        local devoted = {
            loc = {
                name = "奉献小丑",
                text = {
                    "选择{C:attention}Boss盲注{}时",
                    "本牌获得{X:mult,C:white}X0.5{}倍率",
                    "并使{C:attention}资金{C:attention}归零",
                    "{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}倍率）"
                }
            },
            ability_name = "Devoted Joker",
            slug = "devoted",
            ability = {
                extra = {
                    x_mult = 1
                }
            },
            rarity = 3,
            cost = 8,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(devoted)
        -- Set local variables
        function SMODS.Jokers.j_devoted.loc_def(card)
            return { card.ability.extra.x_mult }
        end
        -- Calculate
        SMODS.Jokers.j_devoted.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                if self.ability.extra.x_mult > 1 then
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.x_mult } },
                        Xmult_mod = self.ability.extra.x_mult
                    }
                end
            elseif context.setting_blind and not self.getting_sliced then
                if not context.blueprint and context.blind.boss and not self.getting_sliced then
                    ease_dollars(-G.GAME.dollars, true)
                    self.ability.extra.x_mult = self.ability.extra.x_mult + 0.5
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED
                    }
                end
            end
        end
    end

    -- Pawn Joker
    if config.j_pawn then
        -- Create Joker
        local pawn = {
            loc = {
                name = "当铺小丑",
                text = {
                    "售出卡牌时",
                    "有{C:green}#1#/#2#{}的几率",
                    "获得{C:attention}$3"
                }
            },
            ability_name = "Pawn Joker",
            slug = "pawn",
            ability = {
                extra = {
                    odds = 2,
                    dollars = 3
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(pawn)
        -- Set local variables
        function SMODS.Jokers.j_pawn.loc_def(card)
            return { G.GAME.probabilities.normal, card.ability.extra.odds}
        end
        -- Calculate
        SMODS.Jokers.j_pawn.calculate = function(self, context)
            if context.selling_card then
                if pseudorandom('pawn_broker') < G.GAME.probabilities.normal / self.ability.extra.odds then
                    ease_dollars(self.ability.extra.dollars)
                    return {
                        message = localize('$')..self.ability.extra.dollars,
                        colour = G.C.MONEY,
                        delay = 0.45,
                        card = self
                    }
                end
            end
        end
    end

    -- Scrapper Joker
    if config.j_scrapper then
        -- Create Joker
        local scrapper = {
            loc = {
                name = "好斗小丑",
                text = {
                    "有{C:green}#1#/#2#{}的几率",
                    "在弃掉五张{C:attention}数字{}牌时",
                    "随机生成一张{C:attention}星球牌"
                }
            },
            ability_name = "Scrapper Joker",
            slug = "scrapper",
            ability = {
                extra = {
                    odds = 3
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(scrapper)
        -- Set local variables
        function SMODS.Jokers.j_scrapper.loc_def(card)
            return { G.GAME.probabilities.normal, card.ability.extra.odds}
        end
        -- Calculate
        SMODS.Jokers.j_scrapper.calculate = function(self, context)
            if context.discard and context.other_card == context.full_hand[#context.full_hand] then
                local numbered_cards = 0
                for k, v in ipairs(context.full_hand) do
                    if (v:get_id() ~= 14 and not v:is_face()) then numbered_cards = numbered_cards + 1 end
                end
                if numbered_cards >= 5 and pseudorandom('scrapper') < G.GAME.probabilities.normal / self.ability.extra.odds then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                    return {
                        message = localize('k_plus_planet'),
                        colour = G.C.SECONDARY_SET.Planet,
                        card = self
                    }
                end
            end
        end
    end

    -- Old Man Joker
    if config.j_old_man then
        -- Create Joker
        local old_man = {
            loc = {
                name = "老叟小丑",
                text = {
                    "选择{C:attention}Boss盲注时",
                    "免费生成一个{C:attention}空灵标签"
                }
            },
            ability_name = "Old Man Joker",
            slug = "old_man",
            ability = {
                extra = {
                }
            },
            rarity = 2,
            cost = 6,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(old_man)
        -- Set local variables
        function SMODS.Jokers.j_old_man.loc_def(card)
            return {}
        end
        -- Calculate
        SMODS.Jokers.j_old_man.calculate = function(self, context)
            if context.setting_blind and not self.getting_sliced then
                if not context.blueprint and context.blind.boss then
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            add_tag(Tag('tag_ethereal'))
                            play_sound('generic1', 0.6 + math.random()*0.1, 0.8)
                            play_sound('holo1', 1.1 + math.random()*0.1, 0.4)
                            return true
                        end)
                    }))
                end
            end
        end
    end


    -- Box of Stuff
    if config.j_box_of_stuff then
        -- Create Joker
        local box_of_stuff = {
            loc = {
                name = "拆封快递",
                text = {
                    "选择{C:attention}Boss盲注{}时",
                    "免费生成三个{C:attention}标准标签",
                    "并摧毁本牌"
                }
            },
            ability_name = "Box of Stuff",
            slug = "box_of_stuff",
            ability = {
                extra = {
                }
            },
            rarity = 2,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = false
        }
        -- Initialize Joker
        init_joker(box_of_stuff)
        -- Set local variables
        function SMODS.Jokers.j_box_of_stuff.loc_def(card)
            return {}
        end
        -- Calculate
        SMODS.Jokers.j_box_of_stuff.calculate = function(self, context)
            if context.setting_blind and not self.getting_sliced then
                if not context.blueprint and context.blind.boss then
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            add_tag(Tag('tag_standard'))
                            add_tag(Tag('tag_standard'))
                            add_tag(Tag('tag_standard'))
                            play_sound('generic1', 0.6 + math.random()*0.1, 0.8)
                            play_sound('holo1', 1.1 + math.random()*0.1, 0.4)
                            self.T.r = -0.2
                            self:juice_up(0.3, 0.4)
                            self.states.drag.is = true
                            self.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.jokers:remove_card(self)
                                    self:remove()
                                    self = nil
                                    return true;
                                end})) 
                            return true
                        end)
                    }))
                end
            end
        end
    end

    -- Expanded Art Joker
    if config.j_expanded_art then
        -- Create Joker
        local expanded_art = {
            loc = {
                name = "小丑半身像",
                text = {
                    "{C:attention}增强卡牌{}在计分时",
                    "给予{C:chips}+30{}筹码"
                }
            },
            ability_name = "Expanded Art Joker",
            slug = "expanded_art",
            ability = {
                extra = {
                    chips = 30
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(expanded_art)
        -- Set local variables
        function SMODS.Jokers.j_expanded_art.loc_def(card)
            return { card.ability.extra.chips }
        end
        -- Calculate
        SMODS.Jokers.j_expanded_art.calculate = function(self, context)
            if context.individual and context.cardarea == G.play and context.other_card.ability.set == 'Enhanced' then
                return {
                    chips = self.ability.extra.chips,
                    colour = G.C.RED,
                    card = self
                }
            end
        end
    end

    -- Highlander Joker
    if config.j_highlander then
        -- Create Joker
        local highlander = {
            loc = {
                name = "高地小丑",
                text = {
                    "打出{C:attention}高牌{}时",
                    "每张计分的牌",
                    "永久获得{C:chips}+20{}筹码"
                }
            },
            ability_name = "Highlander Joker",
            slug = "highlander",
            ability = {
                extra = {
                    chip_bonus = 20
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(highlander)
        -- Set local variables
        function SMODS.Jokers.j_highlander.loc_def(card)
            return { card.ability.extra.chip_bonus }
        end
        -- Calculate
        SMODS.Jokers.j_highlander.calculate = function(self, context)
            if context.individual and context.cardarea == G.play then
                if context.scoring_name == "High Card" then
                    if not context.other_card.debuff then
                        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + self.ability.extra.chip_bonus
                        return {
                            chip_bonus = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                            colour = G.C.CHIPS,
                            card = self
                        }
                    end
                end
            end
        end
    end


    -- Lieutenant Joker
    if config.j_lieutenant then
        -- Create Joker
        local lieutenant = {
            loc = {
                name = "Lieutenant Joker",
                text = {
                    "After you play a {C:attention}High Card{}",
                    "increase the {C:attention}rank{}",
                    "of each card played."
                }
            },
            ability_name = "Lieutenant Joker",
            slug = "lieutenant",
            ability = {
                extra = {
                }
            },
            rarity = 3,
            cost = 8,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(lieutenant)
        -- Set local variables
        function SMODS.Jokers.j_lieutenant.loc_def(card)
            return {}
        end
        -- Calculate
        SMODS.Jokers.j_lieutenant.calculate = function(self, context)
            if context.individual and context.cardarea == G.play then
                if context.scoring_name == "High Card" then
                    for k, v in ipairs(context.full_hand) do
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                            local card = v
                            local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                            local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
                            if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                            elseif rank_suffix == 10 then rank_suffix = 'T'
                            elseif rank_suffix == 11 then rank_suffix = 'J'
                            elseif rank_suffix == 12 then rank_suffix = 'Q'
                            elseif rank_suffix == 13 then rank_suffix = 'K'
                            elseif rank_suffix == 14 then rank_suffix = 'A'
                            end
                            card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                        return true end }))
                    end
                end
            end
        end
    end

    -- Cut the Cheese
    if config.j_cut_the_cheese then
        -- Create Joker
        local cut_the_cheese = {
            loc = {
                name = "切奶酪",
                text = {
                    "选择{C:attention}盲注{}时",
                    "随机生成一张{C:attention}食物小丑牌",
                    "{C:inactive}（必须有空位）"
                }
            },
            ability_name = "Cut the Cheese",
            slug = "cut_the_cheese",
            ability = {
                extra = {
                }
            },
            rarity = 3,
            cost = 8,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(cut_the_cheese)
        -- Set local variables
        function SMODS.Jokers.j_cut_the_cheese.loc_def(card)
            return {}
        end
        -- Calculate
        SMODS.Jokers.j_cut_the_cheese.calculate = function(self, context)
            if context.setting_blind then
                if not (context.blueprint_card or self).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                    local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
                    local food_list = {
                        "j_popcorn",
                        "j_gros_michel",
                        "j_ice_cream",
                        "j_turtle_bean",
                        "j_ramen",
                        "j_selzer",
                        "j_diet_cola"
                    }
                    if SMODS.findModByID("sdm_0s_stuff") then
                        table.insert(food_list, "j_sdm_pizza")
                        table.insert(food_list, "j_sdm_burger")
                    end
                    if SMODS.findModByID("MystJokers") then
                        -- table.insert(food_list, "j_myst_exploding_fruitcake")
                        table.insert(food_list, "j_myst_miracle_milk")
                    end
                    if SMODS.findModByID("MoreFluff") then
                        table.insert(food_list, "j_mf_teacup")
                        table.insert(food_list, "j_mf_tonersoup")
                        table.insert(food_list, "j_mf_goldencarrot")
                        table.insert(food_list, "j_mf_lollipop")
                    end
                    if SMODS.findModByID("CheesyJokers") then
                        table.insert(food_list, "j_cj_cheese_wedge")
                        table.insert(food_list, "j_cj_macarons")
                    end
                    if SMODS.findModByID("Bunco") then
                        table.insert(food_list, "j_starfruit")
                    end
                    if SMODS.findModByID("mtl_jkr") then
                        table.insert(food_list, "j_cherry")
                        table.insert(food_list, "j_cafeg")
                    end
                    G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local chosen_joker = pseudorandom_element(food_list, pseudoseed('ctc'))
                            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen_joker, nil)
                            card:add_to_deck()
                            G.jokers:emplace(card)
                            G.GAME.joker_buffer = 0
                            return true
                        end}))   
                        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE}) 
                end
            end
        end
    end


    -- Shady Dealer
    if config.j_shady_dealer then
        -- Create Joker
        local shady_dealer = {
            loc = {
                name = "不法商贩",
                text = {
                    "售出本牌即可免费",
                    "生成一个{C:attention}负片标签"
                }
            },
            ability_name = "Shady Dealer",
            slug = "shady_dealer",
            ability = {
                extra = {
                }
            },
            rarity = 3,
            cost = 10,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = false
        }
        -- Initialize Joker
        init_joker(shady_dealer)
        -- Set local variables
        function SMODS.Jokers.j_shady_dealer.loc_def(card)
            return {}
        end
        -- Calculate
        SMODS.Jokers.j_shady_dealer.calculate = function(self, context)
            if context.selling_self then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_negative'))
                        play_sound('generic1', 0.6 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.1 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end
    end

    -- Suspicious Vase
    if config.j_suspicious_vase then
        -- Create Joker
        local suspicious_vase = {
            loc = {
                name = "蹊跷花瓶",
                text = {
                    "打出的所有{C:attention}2{}、{C:attention}3{}和{C:attention}4",
                    "均变为{C:attention}玻璃牌",
                    "且可给予{X:mult,C:white}X2{}倍率"
                }
            },
            ability_name = "Suspicious Vase",
            slug = "suspicious_vase",
            ability = {
                extra = {
                    x_mult = 2
                }
            },
            rarity = 2,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(suspicious_vase)
        -- Set local variables
        function SMODS.Jokers.j_suspicious_vase.loc_def(card)
            return { card.ability.extra.x_mult }
        end
        -- Calculate
        SMODS.Jokers.j_suspicious_vase.calculate = function(self, context)
            if context.individual and context.cardarea == G.play then
                if (context.other_card:get_id() == 2 or context.other_card:get_id() == 3 or context.other_card:get_id() == 4) then
                    if context.other_card.ability.name == 'Glass Card' then
                        return nil
                    end
                    context.other_card:set_ability(G.P_CENTERS.m_glass, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.other_card:juice_up()
                            return true
                        end
                    }))
                    return {
                        x_mult = self.ability.extra.x_mult,
                        card = self
                    } 
                end
            end
        end
    end

    -- Mural Menace
    if config.j_mural_menace then
        -- Create Joker
        local mural_menace = {
            loc = {
                name = "Mural Menace",
                text = {
                    "Create a random {C:attention}Tag{}",
                    "when you skip a {C:attention}Blind{}"
                }
            },
            ability_name = "Mural Menace",
            slug = "mural_menace",
            ability = {
                extra = {
                }
            },
            rarity = 2,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(mural_menace)
        -- Set local variables
        function SMODS.Jokers.j_mural_menace.loc_def(card)
            return {}
        end
        -- Calculate
        SMODS.Jokers.j_mural_menace.calculate = function(self, context)
            if context.skip_blind then
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    if G.FORCE_TAG then return G.FORCE_TAG end
                    local i = 1
                    while i <= 1 do
                      local _pool, _pool_key = get_current_pool('Tag', nil, nil, nil)
                      local _tag_name = pseudorandom_element(_pool, pseudoseed(_pool_key))
                      local it = 1
                      while _tag_name == 'UNAVAILABLE' or _tag_name == "tag_double" or _tag_name == "tag_orbital" do
                          it = it + 1
                          _tag_name = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
                      end
            
                      G.GAME.round_resets.blind_tags = G.GAME.round_resets.blind_tags or {}
                      local _tag = Tag(_tag_name, nil, G.GAME.blind)
                      add_tag(_tag)
                      i = i + 1
                    end
                    return true end }))
            end
        end
    end


    -- Chicken Scratch
    if config.j_chicken_scratch then
        -- Create Joker
        local chicken_scratch = {
            loc = {
                name = "鸡爪挠地",
                text = {
                    "打出{C:attention}8{}、{C:attention}7{}或{C:attention}3{}并计分时",
                    "本牌获得{C:chips}+5{}筹码",
                    "{C:inactive}（当前为{C:chips}+#1#{C:inactive}筹码）"
                }
            },
            ability_name = "Chicken Scratch",
            slug = "chicken_scratch",
            ability = {
                extra = {
                    chips = 20,
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(chicken_scratch)
        -- Set local variables
        function SMODS.Jokers.j_chicken_scratch.loc_def(card)
            return { card.ability.extra.chips }
        end
        -- Calculate
        SMODS.Jokers.j_chicken_scratch.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                local chickenfood = false
                for k, v in ipairs(context.scoring_hand) do
                    if (v:get_id() == 8 or v:get_id() == 7 or v:get_id() == 3) then
                        chickenfood = true
                    end
                end
                if not chickenfood then
                    return {
                        message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                        chip_mod = self.ability.extra.chips,
                        colour = G.C.CHIPS
                    }
                end
                self.ability.extra.chips = self.ability.extra.chips + 5
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                    end}))
                return {
                    message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                    chip_mod = self.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end

    -- Chalk Outline
    if config.j_chalk_outline then
        -- Create Joker
        local chalk_outline = {
            loc = {
                name = "凶案现场",
                text = {
                    "{C:attention}最后一次出牌{}时",
                    "本牌获得{C:mult}+6{}倍率",
                    "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
                }
            },
            ability_name = "Chalk Outline",
            slug = "chalk_outline",
            ability = {
                extra = {
                    mult = 0,
                }
            },
            rarity = 1,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(chalk_outline)
        -- Set local variables
        function SMODS.Jokers.j_chalk_outline.loc_def(card)
            return { card.ability.extra.mult }
        end
        -- Calculate
        SMODS.Jokers.j_chalk_outline.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                if G.GAME.current_round.hands_left == 0 then
                    self.ability.extra.mult = self.ability.extra.mult + 6
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end}))
                end
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                }
            end
        end
    end


    -- Boredom Slayer
    if config.j_boredom_slayer then
        -- Create Joker
        local boredom_slayer = {
            loc = {
                name = "无聊终结者",
                text = {
                    "出牌时，使{C:attention}盲注{}的",
                    "最低得分要求",
                    "削减{C:attention}10%"
                }
            },
            ability_name = "Boredom Slayer",
            slug = "boredom_slayer",
            ability = {
                extra = {
                    reduction = 0.9
                }
            },
            rarity = 3,
            cost = 8,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(boredom_slayer)
        -- Set local variables
        function SMODS.Jokers.j_boredom_slayer.loc_def(card)
            return { card.ability.extra.reduction }
        end
        -- Calculate
        SMODS.Jokers.j_boredom_slayer.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 0.9)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    
                    local chips_UI = G.hand_text_area.blind_chips
                    G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                    G.HUD_blind:recalculate() 
                    chips_UI:juice_up()
            
                    if not silent then play_sound('chips2') end
                    return true end }))
            end
        end
    end

    -- Cardslinger
    if config.j_cardslinger then
        -- Create Joker
        local cardslinger = {
            loc = {
                name = "飞牌大师",
                text = {
                    "当前出牌中",
                    "每有一张计分的牌",
                    "{C:chips}+10{}筹码"
                }
            },
            ability_name = "Cardslinger",
            slug = "cardslinger",
            ability = {
                extra = {
                    trigger_count = 0,
                    chips = 10,
                    clear_cache = false,
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(cardslinger)
        -- Set local variables
        function SMODS.Jokers.j_cardslinger.loc_def(card)
            return { card.ability.extra.chips }
        end
        -- Calculate
        SMODS.Jokers.j_cardslinger.calculate = function(self, context)
            if context.individual and context.cardarea == G.play then
                if self.ability.extra.clear_cache then
                    self.ability.extra.trigger_count = 0
                    self.ability.extra.clear_cache = false
                end
                self.ability.extra.trigger_count = self.ability.extra.trigger_count + 1
            end
            if context.joker_main and context.cardarea == G.jokers then
                self.ability.extra.clear_cache = true
                self.ability.extra.chips = 10 * self.ability.extra.trigger_count
                return {
                    message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                    chip_mod = self.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end

    -- Sunday Funnies
    if config.j_sunday_funnies then
        -- Create Joker
        local sunday_funnies = {
            loc = {
                name = "周日乐淘淘",
                text = {
                    "在商店中每{C:attention}重掷{}两次",
                    "随机生成一张{C:planet}星球牌{}或{C:tarot}塔罗牌",
                    "{C:inactive}（必须有空位）",
                    "{C:inactive}（还需重掷{C:green}#1#{C:inactive}次）"
                }
            },
            ability_name = "Sunday Funnies",
            slug = "sunday_funnies",
            ability = {
                extra = {
                    counter = 2
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(sunday_funnies)
        -- Set local variables
        function SMODS.Jokers.j_sunday_funnies.loc_def(card)
            return { card.ability.extra.counter }
        end
        -- Calculate
        SMODS.Jokers.j_sunday_funnies.calculate = function(self, context)
            if context.reroll_shop and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                if self.ability.extra.counter == 1 then
                    local tarot_or_planet = pseudorandom_element({1, 2}, pseudoseed('sunday_funnies'))
                    if tarot_or_planet == 1 then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                G.E_MANAGER:add_event(Event({
                                    func = function() 
                                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'car')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end}))   
                                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                                return true
                            end)}))
                    end
                    if tarot_or_planet == 2 then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                G.E_MANAGER:add_event(Event({
                                    func = function() 
                                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end}))   
                                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})                       
                                return true
                            end)}))
                    end
                    self.ability.extra.counter = 2
                else
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        play_sound('tarot1')
                        self:juice_up(0.3, 0.5)
                        return true end }))
                    self.ability.extra.counter = self.ability.extra.counter - 1
                end
            end
        end
    end



    -- Self Portrait
    if config.j_self_portrait then
        -- Create Joker
        local self_portrait = {
            loc = {
                name = "自画像",
                text = {
                    "{C:attention}#1#{}时",
                    "本牌获得{X:mult,C:white}X0.1{}倍率",
                    "每个盲注改变上述要求",
                    "{C:inactive}（当前为{X:mult,C:white}X#2#{C:inactive}倍率）"
                }
            },
            ability_name = "Self Portrait",
            slug = "self_portrait",
            ability = {
                extra = {
                    ability_loc = "使用塔罗牌",
                    ability_state = 1,
                    x_mult = 1
                }
            },
            rarity = 3,
            cost = 8,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(self_portrait)
        -- Set local variables
        function SMODS.Jokers.j_self_portrait.loc_def(card)
            return { card.ability.extra.ability_loc, card.ability.extra.x_mult }
        end
        -- Calculate
        SMODS.Jokers.j_self_portrait.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers and self.ability.extra.x_mult > 1 then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.x_mult } },
                    Xmult_mod = self.ability.extra.x_mult
                }
            elseif context.using_consumeable then
                if not context.blueprint and context.consumeable.ability.set == 'Tarot' and self.ability.extra.ability_state == 1 then
                    self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end}))
                    return
                elseif not context.blueprint and context.consumeable.ability.set == 'Planet' and self.ability.extra.ability_state == 2 then
                    self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end}))
                    return
                end
            elseif not context.blueprint and context.cards_destroyed and self.ability.extra.ability_state == 3 then
                self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                    end}))
                return
            elseif not context.blueprint and context.cardarea == G.jokers and self.ability.extra.ability_state == 4 and context.full_hand and #context.full_hand <= 3 then
                self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                    end}))
                return
            elseif not context.blueprint and context.discard and self.ability.extra.ability_state == 5 then
                local face_cards = 0
                for k, v in ipairs(context.full_hand) do
                    if v:is_face() then face_cards = face_cards + 1 end
                end
                if face_cards >= 3 then
                    self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end}))
                    return
                end
            elseif not context.blueprint and context.cardarea == G.jokers and context.before then
                if self.ability.extra.ability_state == 6 and next(context.poker_hands['High Card']) then
                    self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end}))
                    return
                elseif self.ability.extra.ability_state == 7 and next(context.poker_hands['Straight']) then
                    self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end}))
                    return
                elseif self.ability.extra.ability_state == 8 and next(context.poker_hands['Flush']) then
                    self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end}))
                    return
                end
            elseif context.setting_blind and not self.getting_sliced then
                if not context.blueprint  and not self.getting_sliced then
                    local conditions = {
                        "使用塔罗牌",
                        "使用星球牌",
                        "卡牌被摧毁",
                        "打出的牌少于等于3张",
                        "弃掉大于等于3张人头牌",
                        "打出高牌",
                        "打出顺子",
                        "打出同花",
                    }
                    self.ability.extra.ability_state = pseudorandom_element({1, 2, 3, 4, 5, 6, 7, 8}, pseudoseed('self_insert'))
                    self.ability.extra.ability_loc = conditions[self.ability.extra.ability_state]
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        play_sound('tarot1')
                        self:juice_up(0.3, 0.5)
                        return true end }))
                end
            end
        end
    end


    -- Memorable Joker
    if config.j_memorable then
        -- Create Joker
        local memorable = {
            loc = {
                name = "小丑记忆之链",
                text = {
                    "如果打出的牌正好是{C:attention}3{}张",
                    "本牌获得{X:mult,C:white}X0.1{}倍率",
                    "不合要求的出牌将重置倍率",
                    "{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}倍率）"
                }
            },
            ability_name = "Memorable Joker",
            slug = "memorable",
            ability = {
                extra = {
                    x_mult = 1
                }
            },
            rarity = 2,
            cost = 6,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(memorable)
        -- Set local variables
        function SMODS.Jokers.j_memorable.loc_def(card)
            return { card.ability.extra.x_mult }
        end
        -- Calculate
        SMODS.Jokers.j_memorable.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                if context.full_hand and #context.full_hand == 3 then
                    self.ability.extra.x_mult = self.ability.extra.x_mult + 0.1
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.x_mult } },
                        Xmult_mod = self.ability.extra.x_mult
                    }
                end
                self.ability.extra.x_mult = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        end
    end

    -- Tapestry Joker
    if config.j_tapestry then
        -- Create Joker
        local tapestry = {
            loc = {
                name = "挂毯小丑",
                text = {
                    "本赛局内每使用过一{C:attention}种{}消耗牌",
                    "本牌获得{C:mult}+4{}倍率",
                    "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
                }
            },
            ability_name = "Tapestry Joker",
            slug = "tapestry",
            ability = {
                extra = {
                    mult = 0,
                    tapestry_list = {},
                }
            },
            rarity = 2,
            cost = 6,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(tapestry)
        -- Set local variables
        function SMODS.Jokers.j_tapestry.loc_def(card)
            return { card.ability.extra.mult }
        end
        -- Calculate
        SMODS.Jokers.j_tapestry.calculate = function(self, context)
            if context.using_consumeable then
                local tapestry_list = self.ability.extra.tapestry_list
                local result = {
                    id = context.consumeable.ability.order,
                    set = context.consumeable.ability.set,
                }
                for _, item in ipairs(tapestry_list) do
                    if item.id == result.id and item.set == result.set then
                        return nil
                    end
                end
                self.ability.extra.mult = self.ability.extra.mult + 4
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                    end}))
                return
                table.insert(tapestry_list, result)
            end
            if context.joker_main and context.cardarea == G.jokers and self.ability.extra.mult > 0 then
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.extra.mult } },
                    mult = self.ability.extra.mult
                }
            end
        end
    end

    -- Sir Joker
    if config.j_sir then
        -- Create Joker
        local sir = {
            loc = {
                name = "小丑爵士",
                text = {
                    "在{C:attention}Boss盲注{}中",
                    "或{C:attention}最后一次出牌{}计分时",
                    "{X:mult,C:white}X1.5{}倍率"
                }
            },
            ability_name = "Sir Joker",
            slug = "sir",
            ability = {
                extra = {
                    x_mult = 1.5
                }
            },
            rarity = 1,
            cost = 4,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        -- Initialize Joker
        init_joker(sir)
        -- Set local variables
        function SMODS.Jokers.j_sir.loc_def(card)
            return { card.ability.extra.x_mult }
        end
        -- Calculate
        SMODS.Jokers.j_sir.calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers and (G.GAME.current_round.hands_left == 0 or G.GAME.blind.boss) then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.x_mult } },
                    Xmult_mod = self.ability.extra.x_mult
                }
            end
        end
    end


    --end of the loop, dummy, don't go past this
end


-- calculate wanted poster bonus
local calculate_dollaf_bonusref = Card.calculate_dollar_bonus
function Card:calculate_dollar_bonus()
    local calc_dollar_ret_val = calculate_dollaf_bonusref(self)
    if self.debuff then return end
    if self.ability.set == "Joker" then
        if self.ability.name == 'Wanted Poster' and G.GAME.current_round.hands_played == 1 then
            return self.ability.extra.dollars
        end
    end
    return calc_dollar_ret_val
end
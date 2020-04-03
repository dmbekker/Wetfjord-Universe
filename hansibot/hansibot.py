# tmp
# Work with Python 3.6
from typing import List

import discord
import subprocess
import random
import a2s
from hansibotConfig import *


address_hl2dm = ("wetfjord.eu", 27020)
address_tf2 = ("wetfjord.eu", 27015)
address_arma3 = ("wetfjord.eu", 2303)

print(discord.__version__)

client = discord.Client()

@client.event
async def on_message(message):
    # we do not want the bot to reply to itself
    if message.author == client.user:
        return

    # Everything in this if-statement is for universe-admins and universe-mods only:
    if staff[0] in [y.id for y in message.author.roles] or staff[1] in [y.id for y in message.author.roles]:
        if message.content.startswith('!foradminsonly'):
            msg = '{0.author.mention} is an admin'.format(message)
            await client.send_message(message.channel, msg)

        if message.content.startswith('!whitelist add'):
            content = message.content.split()
            msg = 'Whitelisting {}'.format(content[2], message)
            await client.send_message(message.channel, msg)
            whitelistingOutput = subprocess.check_output([whitelistScript, content[2]], stderr=subprocess.STDOUT).decode('utf-8')
            msg = 'Output terminal: {}'.format(whitelistingOutput, message)
            await client.send_message(message.channel, msg)

        if message.content.startswith('!ip'):
            ipOutput = subprocess.check_output([curl, ipsite], stderr=subprocess.STDOUT).decode('utf-8')
            msg = 'Output terminal: {}'.format(ipOutput, message)
            await client.send_message(message.channel, msg)

        if "!HeilHansi" in message.content:
            msg = 'Danke schön {0.author.mention}! https://wetfjord.eu/heilhansi.png '.format(message)
            await client.send_message(message.channel, msg)

        if "!ComradeHansi" in message.content:
            comrade_list = ['Yes comrade?', 'Heil H... Stalin!', 'knock knock who\'s there? COMRADE HANSI!', 'cyka blyat {}'.format(message.author.mention)]
            comrade_item = random.choice(comrade_list)
            msg = '{} https://wetfjord.eu/comradehansi.png '.format(comrade_item, message)
            await client.send_message(message.channel, msg)

    ###### non-admin commands: ######
    if "hansi sucks" in message.content:
        msg = 'You said fucking wut m8?! Fight me bitch'.format(message)
        await client.send_message(message.channel, msg)

    if "!commanderhansi" in message.content:
        commander_list = ['Yes comrade?', 'Well no shit. What\'ve we\'ve got here? A fucking comedian, Private Joker.', 'knock knock who\'s there? COMMANDER HANSI!', 'I bet you\'re the kind of guy that would f-ck a person in the ass and not even have the goddamn common courtesy to give him a reach-around. I\'ll be watching you {}'.format(message.author.mention)]
        commander_item = random.choice(commander_list)
        msg = ' https://wetfjord.eu/commanderhansi.png {}'.format(commander_item, message)
        await client.send_message(message.channel, msg)

###### Specific channels: ######
    ##hl2:dm & tf2##
    if (message.channel.id == '237233849820512267'):
        if message.content.startswith('!on_hl2'):
            players = (a2s.players(address_hl2dm))
            player_count = len(players)
            players_and_score = ""
            for player in players:
                playtime_minutes = player.duration / 60
                players_and_score += player.name + "\t \t" + str(player.score) + "\t \t" + str(playtime_minutes) + "\n"
            msg = '``` Players online: {} \n Name \t \t Score \t \t Playtime (minutes) \n {} ```'.format(player_count, players_and_score)
            await client.send_message(message.channel, msg)

        if message.content.startswith('!on_tf2'):
            players = (a2s.players(address_tf2))
            player_count = len(players)
            players_and_score = ""
            for player in players:
                playtime_minutes = player.duration / 60
                players_and_score += player.name + "\t \t" + str(player.score) + "\t \t" + str(playtime_minutes) + "\n"
            msg = '``` Players online: {} \n Name \t \t Score \t \t Playtime (minutes) \n {} ```'.format(player_count, players_and_score)
            await client.send_message(message.channel, msg)

    ##Arma3##
    if (message.channel.id == '250269739220336642'):
        if message.content.startswith('!on'):
            players = (a2s.players(address_arma3))
            player_count = len(players)
            players_and_score = ""
            for player in players:
                playtime_minutes = player.duration / 60
                players_and_score += player.name + "\t \t" + str(player.score) + "\t \t" + str(playtime_minutes) + "\n"
            msg = '``` Players online: {} \n Name \t \t Score \t \t Playtime (minutes) \n {} ```'.format(player_count, players_and_score)
            await client.send_message(message.channel, msg)

@client.event
async def on_ready():
    print('Logged in as')
    print(client.user.name)
    print(client.user.id)
    print('------')


client.run(TOKEN)

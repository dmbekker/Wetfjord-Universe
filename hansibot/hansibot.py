# tmp
# Name: hansibot.py
# Version: 1.0
# Language & Version: Python 3.6
# Description: Python Discord bot for the Wetfjord Universe (WFU) Discord Server!
# Changelist: 
	# 25/05/2019: Added this block of text, also: !slap

# Works with Python 3.6

# Importing needed packages:

from typing import List # ?
import discord # How else are we going to work with discord?
import subprocess # ?
from hansibotConfig import * # Import the config


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

# Everything here is for everyone to use!
# TODO: turn these into functions maybe? lots of duplicate code

    if "hansi sucks" in message.content:
        msg = 'You said fucking wut m8?! Fight me bitch'.format(message)
        await client.send_message(message.channel, msg)

# Commands (start with !)
    # Heilarious
    if message.content.startswith('!HeilHansi'):
        msg = 'Danke schön {0.author.mention}!'.format(message)
        await client.send_message(message.channel, msg)

    # Gotta love the old IRC commands!
    if message.content.startswith('!slap'):
		content = message.content.split()
        msg = '{0.author.mention} slaps {content[1]} around a bit with a large trout!'.format(message)
        await client.send_message(message.channel,msg)

# What does this do?
@client.event
async def on_ready():
    print('Logged in as')
    print(client.user.name)
    print(client.user.id)
    print('------')

client.run(TOKEN)

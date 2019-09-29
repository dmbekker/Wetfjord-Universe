# tmp
# Work with Python 3.6
from typing import List

import discord
import subprocess
from hansibotConfig import *

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

    if "hansi sucks" in message.content:
        msg = 'You said fucking wut m8?! Fight me bitch'.format(message)
        await client.send_message(message.channel, msg)

    if message.content.contains('!HeilHansi'):
        msg = 'Danke schön {0.author.mention}! https://wetfjord.eu/heilhansi.png '.format(message)
        await client.send_message(message.channel, msg)


@client.event
async def on_ready():
    print('Logged in as')
    print(client.user.name)
    print(client.user.id)
    print('------')


client.run(TOKEN)

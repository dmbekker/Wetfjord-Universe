#! /usr/bin/env python3

# Name: hansibot.py
# Version: 1.0
# Language & Version: Python 3.6
# Description: Python Discord bot for the Wetfjord Universe (WFU) Discord Server!
# Changelist: 
	# 25-05-2019: Added this block of text, also: !slap
	# 26-05-2019: Initiated rewrite of hansibot from discord.Client() to commands.Bot()
	# 28-05-2019: Started all over, fuck this shit, Python 3.7, proper formatting, discord.py >=1.0 here we go!
	
# Works with Python 3.7 & Discord.py <= 1.0!

# Importing needed packages:
import discord # Discord.py
from discord.ext import commands # Package for command interpretation
from hansibotConfig import * # Config of the bot
import random # for all the random stuff


# Initiate bot, with commandprefix '!'
bot = commands.Bot(command_prefix='!', description=DESCRIPTION)

# When the bot is ready:
@bot.event
async def on_ready():
    print('Logged in as')
    print(bot.user.name)
    print(bot.user.id)
    print('Everything ready to go! \n ------')

# Message related stuff:
#@bot.event
async def on_message(message):

# Police messages for anti-Hansi sentiment
	if 'hansi sucks' in message.content:
		ctx.send(f'{message.author.mention}, you bastard!')

        
# Commands:
 
# Ping:
@bot.command()
async def ping(ctx):
    await ctx.send(f'pong, {ctx.message.author.mention}')

# The good old IRC slap command:
@bot.command()
async def slap(ctx, member: discord.Member):
	# Write error here (something like ' you need to @mention someone before you can slap them'
	await ctx.send(f'{ctx.message.author.mention} slaps {member.mention} around with a big trout!')

# HeilHansi:
@bot.command()
async def HeilHansi(ctx):
	await ctx.send(f'Danke schön, {ctx.message.author.mention}!')

# Whitelist related:
# fixpls vb

# Add:
@bot.command()
async def whitelistAdd(ctx):
	await ctx.send(f'Whitelisted: {ctx.message.content}')

# Remove
@bot.command()
async def whitelistRemove(ctx):
	await ctx.send(f'Removed :{ctx.message.content}')	

	
bot.run(TOKEN)

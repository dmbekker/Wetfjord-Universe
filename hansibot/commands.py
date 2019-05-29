#! /usr/bin/env python3

# Commands:
 
# The Hello World of commands!
@bot.command()
async def ping(ctx):
    await ctx.send(f'pong, {ctx.message.author.mention}')

# Good old IRC slap command!
@bot.command()
async def slap(ctx, member: discord.Member):
	# Write error here (something like ' you need to @mention someone before you can slap them'
	await ctx.send(f'{ctx.message.author.mention} slaps {member.mention} around with a big trout!')

# HeilHansi
@bot.command()
async def HeilHansi(ctx):
	await ctx.send(f'Danke schön, {ctx.message.author.mention}!')

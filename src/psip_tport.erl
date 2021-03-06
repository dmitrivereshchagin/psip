%%%
%%% Copyright (c) 2020 Dmitry Poroh
%%% All rights reserved.
%%% Distributed under the terms of the MIT License. See the LICENSE file.
%%%
%%% Piraha SIP Stack
%%% SIP transport
%%%

-module(psip_tport).

-export([start_udp/1,
         stop_udp/0,
         local_uri/0,
         send_request/1]).
-export_type([start_opts/0]).

-export([start_link/2]).

%%===================================================================
%% Types
%%===================================================================

-type type() :: udp.
-type start_ret() :: ok |
                     {error, {already_started, pid()}} |
                     {error, term()}.
-type start_link_ret() :: {ok, pid()} |
                          {error, {already_started, pid()}} |
                          {error, term()}.
-type start_opts() :: psip_tport_udp:start_opts().

%%===================================================================
%% API
%%===================================================================

-spec start_udp(start_opts()) -> start_ret().
start_udp(UdpStartOpts) ->
    case psip_tport_sup:start_child([udp, UdpStartOpts]) of
        {ok, _Pid} ->
            ok;
        Error ->
            Error
    end.

-spec stop_udp() -> ok.
stop_udp() ->
    psip_tport_udp:stop().

-spec local_uri() -> ersip_uri:uri().
local_uri() ->
    psip_tport_udp:local_uri().

-spec send_request(ersip_request:request()) -> ok.
send_request(OutReq) ->
    psip_tport_udp:send_request(OutReq).

%%===================================================================
%% Called from supervisor
%%===================================================================

-spec start_link(type(), start_opts()) -> start_link_ret().
start_link(udp, StartOpts) ->
    psip_tport_udp:start_link(StartOpts).

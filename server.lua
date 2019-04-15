addEventHandler("onDebugMessage",root,function(message,level,file,line)
    triggerClientEvent(root,"debug.sendClient",root,level,line,message,"server");
end);
trigger ContentDocumentAllUser on ContentDocumentLink (before insert) {
    for(ContentDocumentLink cont : Trigger.new) { 
        cont.Visibility = 'AllUsers'; 
    }
}
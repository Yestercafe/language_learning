maybe2Either :: Maybe a -> Either () a
maybe2Either a =
    case a of
        Just a -> Right a
        Nothing -> Left ()

either2Maybe :: Either () a -> Maybe a
either2Maybe a =
    case a of
        Left _ -> Nothing
        Right a -> Just a
